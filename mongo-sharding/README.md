# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker-compose up -d
```

Запускаем конфигурацию шардинга и наполнение данными БД

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080
Кол-во документов в БД: http://localhost:8080/helloDoc/count
Список всех документов: http://localhost:8080/helloDoc/users

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Как остановить

```shell
docker-compose down
```

### Чтобы почистить все, что связано с проектом

```shell
docker-compose down -v --rmi all --remove-orphans
```
