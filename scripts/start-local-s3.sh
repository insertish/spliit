result=$(docker ps | grep spliit-minio)
if [ $? -eq 0 ];
then
    echo "minio is already running, doing nothing"
else
    echo "minio is not running, starting it"
    docker rm minio --force
    mkdir -p minio-data
    docker run --name spliit-minio -d -p 9000:9000 -p 9001:9001 -v "/$(pwd)/minio-data:/data" quay.io/minio/minio server /data --console-address ":9001"
    sleep 5 # Wait for postgres to start
    docker exec -it spliit-minio mc alias set local http://127.0.0.1:9000 minioadmin minioadmin
    docker exec -it spliit-minio mc mb local/spliit
    docker exec -it spliit-minio mc anonymous set download local/spliit
fi
