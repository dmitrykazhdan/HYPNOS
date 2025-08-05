# 🚀 Railway Deployment Guide

## Quick Setup (5 minutes)

### 1. Push Code to GitHub
```bash
git add .
git commit -m "Add Railway deployment files"
git push origin main
```

### 2. Deploy on Railway
1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose your repository
6. Select the `server` directory

### 3. Configure Environment Variables
In Railway dashboard, go to your project → Variables tab and add:

```bash
# Required
API_KEY=your-secure-api-key-here
LOCAL_MODEL_PATH=/app/model.gguf

# Optional
GENERATION_TOKENS=256
PORT=8080
```

### 4. Upload Your GGUF Model
1. In Railway dashboard, go to your project
2. Click "Files" tab
3. Upload your GGUF model file
4. Rename it to `model.gguf` (or update LOCAL_MODEL_PATH)

### 5. Deploy
Railway will automatically build and deploy your app!

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_KEY` | ✅ | - | Secure API key for authentication |
| `LOCAL_MODEL_PATH` | ✅ | - | Path to your GGUF model file |
| `GENERATION_TOKENS` | ❌ | 256 | Max tokens to generate |
| `PORT` | ❌ | 8080 | Port to run on (Railway sets this) |

## API Endpoints

Once deployed, your API will be available at:
- `https://your-app-name.railway.app/health` - Health check
- `https://your-app-name.railway.app/chat` - Chat endpoint
- `https://your-app-name.railway.app/reset` - Reset conversation

## Update Flutter App

Update your Flutter app configuration:
```dart
// In hypnos_app/lib/config/app_config.dart
static const String baseUrl = 'https://your-app-name.railway.app';
static const String apiKey = 'your-secure-api-key-here';
```

## Troubleshooting

### Build Issues
- Check Railway logs in the dashboard
- Ensure all dependencies are in `requirements.txt`
- Verify Python version in `runtime.txt`

### Model Loading Issues
- Check if model file is uploaded correctly
- Verify `LOCAL_MODEL_PATH` points to the right file
- Check Railway logs for model loading errors

### API Issues
- Verify `API_KEY` is set correctly
- Check if the app is running (green status in Railway)
- Test health endpoint: `https://your-app.railway.app/health`

## Cost
- Railway charges $5/month for 1GB RAM, 1 CPU
- Perfect for small to medium usage
- Scales automatically based on traffic 