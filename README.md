# dbt blogs <!-- omit in toc -->

[![CI Tests: CircleCI](https://circleci.com/gh/nialloriordan/dbt_blogs/tree/master.svg?style=shield)](https://circleci.com/gh/nialloriordan/dbt_blogs/tree/master)
[![Python Code style: black](https://img.shields.io/badge/Python%20Code%20Style-black-000000.svg)](https://github.com/psf/black)
[![SQL Code style: sqlfluff](https://img.shields.io/badge/SQL%20Code%20Style-sqlfluff-informational)](https://github.com/sqlfluff/sqlfluff)

The purpose of this repository is to handle the end to end pipeline of organising posts in [r/dataengineering](https://www.reddit.com/r/dataengineering/) into pre defined categories via an ML model.

## Table of Contents <!-- omit in toc -->
- [Quick Start](#quick-start)
- [Documentation](#documentation)

## Quick Start

<details>
    <summary>
<a class="btnfire small stroke"><em class="fas fa-chevron-circle-down"></em>&nbsp;&nbsp;Show all details</a>
</summary>


Copy the `.example.env` file to `.env` via `cp .example.env .env` and update the variables as appropriate.

Start the Postgres Data Warehouse:
From within the [postgres](postgres/) folder run:
- `docker network create postgres_bridge`: enable dbt and postgres to communicate
- `make build-reddit-pg`: build the postgres image
- `make run-reddit-pg-local`: run postgres

Start dbt:
From within the [dbt](dbt/) folder run:
- `make build-dbt`: build the dbt image
- `make run-dbt-local:`: run dbt
- `make serve-dbt-docs`: serve dbt documentation at [127.0.0.1:8001](http://127.0.0.1:8001/)

Run dbt commands:
- `docker exec -it docker exec -it dbt_blogs /bin/bash`: enter dbt container
- `dbt run`: run dbt transformations

</details>

## Documentation

The full documentation can be found in the [docs/](docs/) folder.