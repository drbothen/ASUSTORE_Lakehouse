/bin/sh -c "
minio server /data --console-address ':9001' &
sleep 5;
mc alias set myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD;
mc mb myminio/datalake;
mc mb myminio/warehouse;
tail -f /dev/null"