postgres-pull:
	docker pull stackbrew/postgres
postgres-run:
	docker run -d -p 5432:5432 --name=cobudget-postgres stackbrew/postgres
postgres-start:
	docker start cobudget-postgres
postgres-stop:
	docker stop cobudget-postgres
postgres-rm:
	docker rm cobudget-postgres
postgres-logs:
	docker logs cobudget-postgres
