# ASUSTORE Lakehouse

## Services

### **MinIO**
The `minio` service in this Compose file deploys an instance of MinIO, a high-performance object storage solution. Below are the details of its configuration:

- **Image:** `minio/minio:RELEASE.2024-10-02T17-50-41Z`
- **Ports:**
    - `9000:9000`: The main endpoint for accessing MinIO.
    - `9001:9001`: The console UI for managing MinIO.
- **Volumes:**
    - `./volume1/docker/minio/data:/minio-data`: Maps local storage to MinIO's data directory.
- **Networks:**
    - `intro-network`: A custom Docker network for service communication.

---

## Environment Variables

### Required Variables
The following environment variables must be set in your environment or `.env` file before running the Compose setup. Each variable is critical for securing and configuring the MinIO service.

1. **`ASUSTORE_MINIO_ROOT_USER`**
    - **Purpose:** Sets the root username for MinIO.
    - **Description:** This is the administrative username used to authenticate and manage MinIO. Ensure this is a secure and unique username.
    - **Example:** `admin`

2. **`ASUSTORE_MINIO_ROOT_PASSWORD`**
    - **Purpose:** Sets the root password for MinIO.
    - **Description:** This is the administrative password for accessing and managing MinIO. Use a strong password to secure access.
    - **Example:** `SuperSecretPassword123`

3. **`ASUSTORE_MINIO_DOMAIN`**
    - **Purpose:** Specifies the domain name for MinIO.
    - **Description:** Configures the domain name for MinIO, enabling access via the domain instead of directly using IP and port. Set this if you're using MinIO behind a custom domain.
    - **Example:** `minio.example.com`

---

## Additional Details

### Entrypoint Commands
The `entrypoint` initializes the MinIO instance and sets up predefined buckets for object storage. Here's a breakdown:
- **Buckets:**
    - `datalake`: A general-purpose bucket for storing large amounts of raw data.
    - `warehouse`: A bucket intended for processed or refined data.
- **Aliases:**
    - `mc alias set myminio http://localhost:9000 admin password`: Configures the `mc` CLI to manage the MinIO instance locally.

---

## Running the Setup

1. Ensure that Docker and Docker Compose are installed on your machine.
2. Define the required environment variables in a `.env` file or export them in your shell:
   ```env
   ASUSTORE_MINIO_ROOT_USER=admin
   ASUSTORE_MINIO_ROOT_PASSWORD=SuperSecretPassword123
   ASUSTORE_MINIO_DOMAIN=minio.example.com
   ```
3. Start the services:
   ```bash
   docker-compose up -d
   ```
4. Access the MinIO console at `http://localhost:9001` (or `http://<your-domain>:9001` if using a domain).

---

## Notes
- Adjust the volume paths and ports if they conflict with existing configurations on your machine.
- Make sure your domain (if used) resolves correctly to the Docker host machine.

This setup provides a secure and ready-to-use MinIO instance for your data storage needs.# ASUSTORE_Lakehouse