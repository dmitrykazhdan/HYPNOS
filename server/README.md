# 🖥️ HYPNOS AI Server

Flask server providing AI chat and image analysis for the HYPNOS app with authentication.

## ✨ Features

- 🤖 **AI Chat** - Process text messages with local GGUF models
- 🖼️ **Image Analysis** - Analyze photos with vision models (**IN DEVELOPMENT**)
- 🔐 **API Authentication** - Secure endpoints with Bearer token authentication
- ⚡ **Fast Response** - Optimized for real-time interaction
- 🔒 **Local Processing** - No data sent to external services
- 📊 **Health Monitoring** - Model status and performance metrics

## 🚀 Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Copy environment file
cp env.example .env

# Edit .env with your configuration
# - Set LOCAL_MODEL_PATH to your GGUF model
# - Set a secure API_KEY
# - Adjust other settings as needed

# Start server
python server.py

# Server runs on http://localhost:3001
```

## 🔧 Configuration

### Environment Variables (.env file)

```bash
# Model Configuration
LOCAL_MODEL_PATH=/path/to/your/model.gguf
GENERATION_TOKENS=256

# Security (REQUIRED for production)
API_KEY=your-secure-api-key-here

# Server Configuration
PORT=3001
HOST=0.0.0.0
```

### Security Setup

1. **Generate a secure API key** (at least 32 characters)
2. **Set the API_KEY in your .env file**
3. **Update the Flutter app** with the same API key in `app_config.dart`
4. **Deploy with HTTPS** in production

## 📡 API Endpoints

All endpoints require Bearer token authentication in the Authorization header.

### Authentication
```
Authorization: Bearer your-api-key-here
```

### Endpoints

- `GET /health` - Server and model status
- `POST /chat` - Process text messages
- `POST /process_image` - Analyze images (placeholder)
- `POST /reset` - Reset conversation
- `GET /` - Web interface (no auth required)

### Example Request

```bash
curl -X POST http://localhost:3001/chat \
  -H "Authorization: Bearer your-api-key-here" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello, how can you help me sleep better?",
    "history": []
  }'
```

## 🏗️ Architecture

- **Flask** - Lightweight Python web framework
- **Flask-CORS** - Cross-origin resource sharing
- **llama-cpp-python** - Local GGUF model inference
- **Authentication** - Bearer token middleware
- **Threading** - Concurrent request handling

## 📦 Dependencies

- `flask` - Web framework
- `flask-cors` - CORS support
- `llama-cpp-python` - Local model inference
- `python-dotenv` - Environment variable management

## 🚀 Deployment

### Local Development
```bash
python server.py
```

### Production Deployment

1. **Set up a production server** (AWS, GCP, DigitalOcean, etc.)
2. **Install dependencies**: `pip install -r requirements.txt`
3. **Configure environment variables** in `.env`
4. **Use a production WSGI server**:
   ```bash
   pip install gunicorn
   gunicorn -w 4 -b 0.0.0.0:3001 server:app
   ```
5. **Set up HTTPS** with a reverse proxy (nginx/Apache)
6. **Configure firewall** to only allow necessary ports

### Docker Deployment

```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
EXPOSE 3001

CMD ["python", "server.py"]
```

## 🔒 Security Considerations

- ✅ **API Key Authentication** - All endpoints protected
- ✅ **CORS Configuration** - Configure for your app domain
- ✅ **Input Validation** - Sanitize user inputs
- ⚠️ **Rate Limiting** - Consider adding rate limiting
- ⚠️ **HTTPS** - Always use HTTPS in production
- ⚠️ **Model Security** - Keep your GGUF model secure

## 📊 Monitoring

The server provides health monitoring at `/health`:

```json
{
  "status": "healthy",
  "text_model_loaded": true,
  "timestamp": 1640995200.0
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Model not loading**: Check `LOCAL_MODEL_PATH` in `.env`
2. **Authentication errors**: Verify API key matches between server and app
3. **CORS errors**: Check CORS configuration for your domain
4. **Memory issues**: Reduce `GENERATION_TOKENS` or model context size

### Logs

The server provides detailed logging. Check console output for:
- Model loading status
- Request/response logs
- Error messages 