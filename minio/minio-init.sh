#!/bin/bash
# minio-init.sh

# Function to log messages with timestamps
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to wait for MinIO to be ready
wait_for_minio() {
  local attempts=0
  log 'Waiting for MinIO to be ready...'

  while [ $attempts -lt $MAX_RETRY_ATTEMPTS ]; do
    if mc alias set myminio http://$MINIO_HOST:$MINIO_PORT $MINIO_ACCESS_KEY $MINIO_SECRET_KEY >/dev/null 2>&1; then
      log 'Successfully connected to MinIO'
      return 0
    fi
    attempts=$((attempts + 1))
    log "Attempt $attempts/$MAX_RETRY_ATTEMPTS failed. Retrying in $RETRY_INTERVAL s..."
    sleep $RETRY_INTERVAL
  done

  log 'Failed to connect to MinIO after maximum attempts'
  return 1
}

# Function to configure bucket policies
configure_bucket() {
  local bucket=$1

  # Enable versioning if requested
  if [ "$BUCKET_VERSIONING" = "true" ]; then
    log "Enabling versioning for bucket: $bucket"
    mc version enable myminio/$bucket
  fi

  # Set public access if requested
  if [ "$BUCKET_PUBLIC_ACCESS" = "true" ]; then
    log "Setting public read access for bucket: $bucket"
    mc policy set download myminio/$bucket
  fi
}

# Main execution starts here
log 'Starting MinIO initialization'

# Validate environment variables
if [ -z "$MINIO_BUCKETS" ]; then
  log 'Error: No buckets defined in MINIO_BUCKETS'
  exit 1
fi

# Wait for MinIO to be ready
wait_for_minio || exit 1

# Process each bucket
IFS=',' read -ra BUCKETS <<< "$MINIO_BUCKETS"
for BUCKET in "${BUCKETS[@]}"; do
  BUCKET=$(echo "$BUCKET" | tr -d '[:space:]')
  log "Processing bucket: $BUCKET"

  if ! mc ls myminio/$BUCKET >/dev/null 2>&1; then
    if mc mb myminio/$BUCKET; then
      log "Successfully created bucket: $BUCKET"
      configure_bucket "$BUCKET"
    else
      log "Failed to create bucket: $BUCKET"
      exit 1
    fi
  else
    log "Bucket $BUCKET already exists, checking configuration"
    configure_bucket "$BUCKET"
  fi
done

log 'MinIO initialization completed successfully'
