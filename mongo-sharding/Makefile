.PHONY: mongodb-cluster-status

mongodb-cluster-status:
	docker-compose exec router01 mongosh --port 27017 --eval "sh.status()"