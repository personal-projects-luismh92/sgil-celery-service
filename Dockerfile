# Use a minimal Python image
FROM python:3.11-alpine

# Install necessary system dependencies
RUN apk add --no-cache git gcc musl-dev python3-dev libffi-dev curl

# Set the working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Celery worker code
COPY celery_worker /app/celery_worker

# Ensure Celery runs as a non-root user (Fix for Alpine Linux)
RUN adduser -D -u 1000 celery_user

# Create logs directory as root and assign permissions to celery_user
RUN mkdir -p /app/logs && chown -R celery_user:celery_user /app/logs

# Switch to non-root user
USER celery_user

# Set environment variables (overridden in docker-compose.yml)
ENV CELERY_BROKER_URL=redis://redis:6379/0
ENV CELERY_RESULT_BACKEND=redis://redis:6379/0
ENV CELERY_ACCEPT_CONTENT=json
ENV CELERY_TASK_SERIALIZER=json
ENV LOGGING_SERVICE_URL=http://sgil-monitoreo-service:8090/logs

# Expose logs for debugging
ENV CELERYD_LOG_FILE=/app/logs/celery.log

# Default command to start Celery worker
CMD ["celery", "-A", "celery_worker.celery_config.celery", "worker", "--loglevel=info", "--concurrency=4", "-Q", "email_queue,logging_queue"]
