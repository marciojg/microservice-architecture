echo 'stop kafka stack'
docker-compose -f docker-compose-kafka.yml down
sleep 10

echo 'stop wishlist stack'
docker-compose -f docker-compose-wishlist.yml down
sleep 10

echo 'stop other-services stack'
docker-compose -f docker-compose-other-services.yml down
sleep 10

echo "Success!"
