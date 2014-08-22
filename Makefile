build:
	docker build -t cobudget/cobudget-api .
db-create:
	docker run --rm -i -t -v $(shell pwd):/app --link=cobudget-postgres:db cobudget/cobudget-api bundle exec rake db:create
db-migrate:
	docker run --rm -i -t -v $(shell pwd):/app --link=cobudget-postgres:db cobudget/cobudget-api bundle exec rake db:migrate
run:
	docker run --rm -i -t -P -v $(shell pwd):/app --name=cobudget-api --link=cobudget-postgres:db cobudget/cobudget-api
start:
	docker run -d -P -v $(shell pwd):/app --name cobudget-api --link=cobudget-postgres:db cobudget/cobudget-api
stop:
	docker stop cobudget-api && docker rm cobudget-api
logs:
	docker logs cobudget-api

irb:
	docker run --rm -i -t -v $(shell pwd):/app --link=cobudget-postgres:db cobudget/cobudget-api irb
test-spec:
	docker run --rm -i -t -v $(shell pwd):/app --link=cobudget-postgres:db cobudget/cobudget-api bundle exec rake spec
test-features:
	docker run --rm -i -t -v $(shell pwd):/app --link=cobudget-postgres:db cobudget/cobudget-api bundle exec rake features

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
