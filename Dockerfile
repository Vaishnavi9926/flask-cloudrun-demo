# Use official Python slim image
FROM python:3.11-slim

# Install build deps (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only requirements first for caching
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

ENV PORT=8080
EXPOSE 8080

# Run via gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app", "--workers", "2", "--threads", "2", "--timeout", "120"]
