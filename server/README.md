# 🖥️ HYPNOS AI Server

Flask server providing AI chat and (in the future) image analysis for the HYPNOS app.

## ✨ Features

- 🤖 **AI Chat** - Process text messages with local models
- 🖼️ **Image Analysis** - Analyze photos with vision models (**IN DEVELOPMENT**)
- ⚡ **Fast Response** - Optimized for real-time interaction
- 🔒 **Local Processing** - No data sent to external services
- 📊 **Health Monitoring** - Model status and performance metrics

## 🚀 Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Start server
python server.py

# Server runs on http://localhost:3001
```

## 🔧 Configuration

- **Port**: Default 3001 (change in `server.py`)
- **Models**: Configure model paths in server
- **CORS**: Configured for Flutter app
- **Logging**: Detailed request/response logging

## 📡 API Endpoints

- `GET /health` - Server and model status
- `POST /chat` - Process text messages
- `POST /process_image` - Analyze images (text model) (**IN DEVELOPMENT**)
- `POST /process_image_multimodal` - Analyze images (vision model) (**IN DEVELOPMENT**)

## 🏗️ Architecture

- **Flask** - Lightweight Python web framework
- **Flask-CORS** - Cross-origin resource sharing
- **Local Models** - GGUF format for efficiency
- **Multipart** - Handle image uploads
- **Threading** - Concurrent request handling

## 📦 Dependencies

- `flask` - Web framework
- `flask-cors` - CORS support
- `python-multipart` - File uploads
- `llama-cpp-python` - Local model inference 