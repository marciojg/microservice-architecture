echo 'creating network'
docker network create default-net

echo 'creating etcd stack'
docker-compose -f docker-compose-etcd.yml up -d
sleep 5

echo 'populating etcd'
docker-compose -f docker-compose-etcd.yml exec etcd /bin/sh -c "etcdctl --endpoints http://etcd:2379 put development/product_service/client_id 'PRODUCT_SERVICE'"

docker-compose -f docker-compose-etcd.yml exec etcd /bin/sh -c "etcdctl --endpoints http://etcd:2379 put development/product_service/brokers 'kafka:29092'"
sleep 5

echo 'creating kafka stack'
docker-compose -f docker-compose-kafka.yml up -d
sleep 5

echo 'create product stack'
docker-compose -f docker-compose-product.yml up -d
sleep 5

echo 'create wishlist stack'
docker-compose -f docker-compose-wishlist.yml up -d
sleep 5

echo 'create cart stack'
docker-compose -f docker-compose-cart.yml up -d
sleep 5

echo 'create order stack'
docker-compose -f docker-compose-order.yml up -d
sleep 5

echo 'create support stack'
docker-compose -f docker-compose-support.yml up -d
sleep 5

echo 'create freight stack'
docker-compose -f docker-compose-freight.yml up -d
sleep 5

echo "Success!"
