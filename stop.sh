echo 'down kafka stack'
docker-compose -f docker-compose-kafka.yml down -v
sleep 5

echo 'down product stack'
docker-compose -f docker-compose-product.yml down -v
sleep 5

echo 'down wishlist stack'
docker-compose -f docker-compose-wishlist.yml down -v
sleep 5

echo 'down cart stack'
docker-compose -f docker-compose-cart.yml down -v
sleep 5

echo 'down order stack'
docker-compose -f docker-compose-order.yml down -v
sleep 5

echo 'down support stack'
docker-compose -f docker-compose-support.yml down -v
sleep 5

echo 'down freight stack'
docker-compose -f docker-compose-freight.yml down -v
sleep 5

echo 'down etcd stack'
docker-compose -f docker-compose-etcd.yml down -v
sleep 5

echo 'remove network'
docker network rm default-net

echo "Success!"
