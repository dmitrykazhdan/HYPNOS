#!/usr/bin/env python3
from flask import Flask, request, jsonify
from flask_cors import CORS
from llama_cpp import Llama
import threading
import time
import os
import socket
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration from environment variables
GENERATION_TOKENS = int(os.getenv('GENERATION_TOKENS', '256'))
LOCAL_MODEL_PATH = os.getenv('LOCAL_MODEL_PATH', '')

SYSTEM_PROMPT = """
                You are HYPNOS, a helpful AI assistant designed to support users with insomnia and sleep issues.
                Be informative, calm, and supportive. Keep all answers brief and to the point, no more than 200 words.
                Feel free to add emojis when relevant.
                Avoid repeating yourself. If the user asks for details, you can expand later.

                You must not provide information that is unsafe, illegal, or harmful. Refuse to answer any questions about explosives, weapons, self-harm, or other dangerous activities. In general - stick to talking about sleep and sleep issues.
                """

app = Flask(__name__)
CORS(app)

# Global model and lock
chat_model = None
model_lock = threading.Lock()

def get_local_ip():
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            return ip if ip != "127.0.0.1" else "localhost"
    except:
        return "localhost"

def initialize_models():
    global chat_model
    print("🤖 Initializing model...")
    print(f"📁 Model path: {LOCAL_MODEL_PATH}")
    chat_model = Llama(
        model_path=LOCAL_MODEL_PATH,
        n_gpu_layers=0,
        n_ctx=2048,
        verbose=False
    )
    print("✅ Text model loaded!")

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        "status": "healthy",
        "text_model_loaded": chat_model is not None,
        "timestamp": time.time()
    })

def format_prompt_truncated(history, max_tokens=2048, generation_tokens=200):
    """
    Truncates the conversation history to fit within the context window.
    Uses simple word-length estimate (not exact tokens, but works well).
    """
    system = [m for m in history if m["role"] == "system"]
    turns = [m for m in history if m["role"] != "system"]

    # Estimate tokens with a ~1.3x factor (approx LLM tokenization)
    def estimate_tokens(text): return int(len(text.split()) * 1.3)

    total = 0
    selected = []

    # Reverse scan user-model turns from most recent
    for msg in reversed(turns):
        msg_tokens = estimate_tokens(msg["content"])
        if total + msg_tokens >= max_tokens - generation_tokens - 50:  # leave headroom
            break
        selected.insert(0, msg)
        total += msg_tokens

    all_msgs = system + selected
    prompt = ""
    for turn in all_msgs:
        role = turn["role"]
        content = turn["content"].strip()
        prompt += f"<start_of_turn>{role}\n{content}<end_of_turn>\n"

    prompt += "<start_of_turn>model\n"
    return prompt

@app.route('/chat', methods=['POST'])
def chat_endpoint():
    if chat_model is None:
        return jsonify({"error": "Model not initialized"}), 503

    try:
        data = request.get_json()
        if not data or 'message' not in data:
            return jsonify({"error": "Missing 'message' field"}), 400

        user_message = data['message']
        history = data.get("history", [])

        # Default system prompt
        # Always inject system prompt — overwrite any previous one
        system_prompt = {
            "role": "system",
            "content": (
                SYSTEM_PROMPT
            )
        }

        # Remove existing system prompt (if any)
        history = [msg for msg in history if msg["role"] != "system"]
        # Prepend new one
        history.insert(0, system_prompt)

        # Append user message
        history.append({"role": "user", "content": user_message})

        # Construct prompt
        prompt_text = format_prompt_truncated(history, max_tokens=2048, generation_tokens=GENERATION_TOKENS)

        with model_lock:
            output = chat_model(
                prompt_text,
                max_tokens=GENERATION_TOKENS,
                temperature=0.7,
                stop=["<end_of_turn>"]
            )

        assistant_reply = output["choices"][0]["text"].strip()
        history.append({"role": "model", "content": assistant_reply})

        return jsonify({
            "response": assistant_reply,
            "history": history,
            "tokens_used": output.get("usage", {}).get("total_tokens")
        })

    except Exception as e:
        print(f"❌ Error in chat endpoint: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/reset', methods=['POST'])
def reset_conversation():
    return jsonify({
        "message": "Conversation reset",
        "history": [{
            "role": "system",
            "content": (
                SYSTEM_PROMPT
            )
        }]
    })

@app.route('/')
def web_interface():
    html_file_path = os.path.join(os.path.dirname(__file__), 'web_interface.html')
    try:
        with open(html_file_path, 'r', encoding='utf-8') as f:
            html_content = f.read()

        html_content = html_content.replace(
            "const SERVER_URL = 'http://192.168.1.116:5000';",
            "const SERVER_URL = window.location.origin;"
        )
        return html_content
    except FileNotFoundError:
        return "Web interface file not found", 404

if __name__ == '__main__':
    model_thread = threading.Thread(target=initialize_models)
    model_thread.start()

    local_ip = get_local_ip()
    print(f"🔍 Detected local IP: {local_ip}")
    print("🚀 Starting Gemma Chat Server...")
    print("📡 Web interface: http://localhost:3001")
    print(f"📡 Network access: http://{local_ip}:3001")
    print("\n⏳ Waiting for models to load...")

    model_thread.join()
    app.run(host='0.0.0.0', port=3001, debug=True)
