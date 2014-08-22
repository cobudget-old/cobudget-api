build:
	docker build -t cobudget/cobudget-api .
migrate:
	docker run --rm -i --link=cobudget-postgres:postgres cobudget/cobudget-api bundle exec rake db:migrate
run:
	docker run --rm -i --name=cobudget-api --link=cobudget-postgres:postgres cobudget/cobudget-api
start:
	docker start cobudget-api
stop:
	docker stop cobudget-api
rm:
	docker rm cobudget-api
logs:
	docker logs cobudget-api

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
