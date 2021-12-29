# Include the .env file:
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.DEFAULT_GOAL := help 
help:
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

IMAGE_NAME=dbt_blogs

build-dbt: # Build the dbt image
	docker build -t $(IMAGE_NAME) .

run-dbt-local: # Run dbt locally
	docker-compose up

restart-dbt-local: # Restart dbt locally
	docker-compose down && docker-compose up

run-reddit-pg-prod: # Run dbt in prod
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml -d

serve-dbt-docs: # Serve dbt documentation locally
	docker run -it \
		--name serve-dbt-docs \
		--env-file $(PWD)/.env \
		-v $(PWD)/dbt_project/:/home/dbt_user/dbt_project \
		-p 127.0.0.1:8001:8001 \
		--network=postgres_bridge \
		$(IMAGE_NAME):latest \
		/bin/bash -c "dbt docs generate && dbt docs serve --port 8001"
