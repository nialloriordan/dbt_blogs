
.DEFAULT_GOAL := help 
help:
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

DBT_IMAGE_NAME=dbt_blogs
POSTGRES_IMAGE_NAME=reddit_postgres

docs-structure: # create base for structure documentation
	bash structure_tree.sh . > $(PWD)/docs/structure_base.md

poetry-install: # install poetry
	pip --no-cache-dir install poetry==1.2.0a2

requirements: # install all requirements
	poetry install --sync

update-poetry: # update poetry lock file
	poetry update

check-poetry: # check poetry lock file is updated
	poetry lock --check

black: # run formatter with black
	poetry run black postgres/scripts/python

flake8: # check python style with flake8
	poetry run flake8 postgres/scripts/python

isort: # sort python imports
	poetry run isort postgres/scripts/python

sqlfluff: # check sql style in dbt with sqlfluff
	poetry run sqlfluff lint dbt/dbt_project/models

lint-python: flake8 # check python styles
	poetry run black postgres/scripts/python --check
	poetry run isort postgres/scripts/python --check

lint-sql: # check sql styles
	poetry run sqlfluff lint dbt/dbt_project/models

dbt-build: # Build the dbt image
	docker build -t $(DBT_IMAGE_NAME) $(PWD)/dbt/

dbt-serve-docs: # Serve dbt documentation locally
	docker run -it \
		--name serve-dbt-docs \
		--env-file $(PWD)/.env \
		-v $(PWD)/dbt/:/home/dbt_user/dbt_project \
		-p 127.0.0.1:8001:8001 \
		--network=postgres_bridge \
		$(DBT_IMAGE_NAME):latest \
		/bin/bash -c "dbt docs generate && dbt docs serve --port 8001"

dbt-exec-container: # Enter dbt container
	docker exec -it docker exec -it dbt_blogs /bin/bash

pg-build: # Build the reddit postgres image
	docker build -t $(POSTGRES_IMAGE_NAME) ${PWD}/postgres/

run-services-local: # Run the Postgres and dbt containers locally
	docker-compose up

run-services-prod: # Run the Postgres and dbt containers production
	docker-compose -f docker-compose.yml -f docker-compose-prod.yml up -d
