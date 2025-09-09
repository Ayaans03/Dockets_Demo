# ---- Builder Stage ----
FROM python:3.9-slim AS builder
WORKDIR /app

# Install build tools only in the builder
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc libjpeg-dev zlib1g-dev

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY app.py .

# ---- Runtime Stage ----
FROM python:3.9-slim
WORKDIR /app

# Copy only installed packages and app code from builder
COPY --from=builder /install /usr/local
COPY --from=builder /app/app.py .

CMD ["python", "app.py"]
