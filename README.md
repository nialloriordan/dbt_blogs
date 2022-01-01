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

Create a `.env` from the [example.env](../.example.env) via `cp .example.env .env` and update the env variables to match your settings.

Build the docker images:
- `make pg-build`: build the postgres image
- `make dbt-build`: build the dbt image

Start the Postgres and dbt containers:
- `make run-services-local`

Serve the the dbt documentation at [127.0.0.1:8001](http://127.0.0.1:8001/)
- `make dbt-serve-docs`: serve dbt documentation at [127.0.0.1:8001](http://127.0.0.1:8001/)

Run dbt commands:
- `make dbt-exec-container`: enter dbt container
- `dbt run`: run dbt transformations

</details>

## Documentation

The full documentation can be found in the [docs/](docs/) folder.
