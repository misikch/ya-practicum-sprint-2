#!/bin/bash

# Инициализация конфигурационного сервера
docker-compose exec -T configsvr01 mongosh --eval '
rs.initiate({
  _id: "rs-config-server",
  configsvr: true,
  version: 1,
  members: [{ _id: 0, host: "configsvr01:27017" }]
});
'
wait

# Инициализация первого шарда
docker-compose exec -T shard01-a mongosh --eval '
rs.initiate({
  _id: "rs-shard-01",
  version: 1,
  members: [
    { _id: 0, host: "shard01-a:27017" }
  ]
});
'
wait

# Инициализация второго шарда
docker-compose exec -T shard02-a mongosh --eval '
rs.initiate({
  _id: "rs-shard-02",
  version: 1,
  members: [
    { _id: 0, host: "shard02-a:27017" }
  ]
});
'
wait

echo
echo "MongoDB replica set инициированы. Ожидаем 5 секунд и запускаем настройку роутера."
echo

# Тут нужно подождать до конфигурации роутера
sleep 5

docker-compose exec -T router01 mongosh --eval '
sh.addShard("rs-shard-01/shard01-a:27017")
sh.addShard("rs-shard-02/shard02-a:27017")
'

wait

echo
echo "MongoDB replica set включаем шардирование для db: somedb"
echo

# Включаем шардирование
docker-compose exec -T router01 mongosh --eval '
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { age: "hashed" })
'

wait


echo
echo "MongoDB replica set инициализация завершена."
echo

sleep 2


echo
echo "Запускаем наполнение БД данными..."
echo
###
# Наполняем БД
###

docker compose exec -T router01 mongosh <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

wait

echo
echo
echo "Данные в БД 'helloDoc' загружены."
echo
echo "Используйте url http://localhost:8080/ для получения статуса и http://localhost:8080/helloDoc/users для получения списка документов"