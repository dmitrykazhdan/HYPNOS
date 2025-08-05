#!/usr/bin/env python3
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        "status": "healthy",
        "message": "Minimal test server is working!",
        "port": os.getenv('PORT', 'unknown')
    })

@app.route('/', methods=['GET'])
def root():
    return jsonify({
        "message": "Minimal Test Server",
        "status": "running"
    })

if __name__ == '__main__':
    try:
        port = int(os.getenv('PORT', 3001))
        print(f"🚀 Starting Minimal Test Server v2 on port {port}...")
        print(f"🔑 Environment check: PORT={os.getenv('PORT')}")
        print(f"🔧 Using minimal_test.py (not server.py)")
        print(f"🔧 Flask app object: {app}")
        app.run(host='0.0.0.0', port=port, debug=False)
    except Exception as e:
        print(f"❌ CRASH: {e}")
        import traceback
        traceback.print_exc()
        raise 