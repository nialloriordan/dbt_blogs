# Include the .env file:
ifneq (,$(wildcard ../.env))
    include .env
    export
endif

.DEFAULT_GOAL := help 
help:
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

IMAGE_NAME=reddit_postgres

build-reddit-pg: # Build the reddit postgres image
	docker build -t $(IMAGE_NAME) .

run-reddit-pg-local: # Run the Reddit postgres locally
	docker-compose up

restart-reddit-pg-local: # Restart the Reddit postgres locally
	docker-compose down && docker-compose up

run-reddit-pg-prod: # Run the Reddit postgres in prod
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml -d
