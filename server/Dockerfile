# Use Python 3.11 slim image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Install system dependencies and gcsfuse
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    gnupg \
    lsb-release \
    && echo "deb http://packages.cloud.google.com/apt gcsfuse-$(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/gcsfuse.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y gcsfuse \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create mount point for model
RUN mkdir -p /models

# Expose port
EXPOSE 8080

# Run the application with gcsfuse
CMD gcsfuse --implicit-dirs hypnos-models /models && exec gunicorn --bind :$PORT --workers 1 --threads 4 --timeout 120 server:app 

