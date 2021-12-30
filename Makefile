
.DEFAULT_GOAL := help 
help:
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

install-poetry: # install poetry
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

sqlfluff: # check sql style in dbt with sqlfluff
	poetry run sqlfluff lint dbt/dbt_project/models

lint: black flake8 sqlfluff # check python and sql styles