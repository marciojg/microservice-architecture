echo 'creating kafka stack'
docker-compose -f docker-compose-kafka.yml up -d
sleep 10

echo 'create wishlist stack'
docker-compose -f docker-compose-wishlist.yml up -d
sleep 10


echo 'create cart stack'
docker-compose -f docker-compose-cart.yml up -d
sleep 10

echo 'create other-services stack'
docker-compose -f docker-compose-other-services.yml up -d
sleep 10

echo "Success!"
