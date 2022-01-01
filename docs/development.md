# Development <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->
- [Makefile](#makefile)
- [Poetry - dependency manager](#poetry---dependency-manager)
- [Docker](#docker)
- [Postgres](#postgres)
  - [Building the image](#building-the-image)
  - [Running Postgres](#running-postgres)
- [dbt](#dbt)
  - [local development](#local-development)
  - [docker container](#docker-container)
    - [Building the image](#building-the-image-1)
    - [Running dbt](#running-dbt)
- [Linting](#linting)
  - [Python](#python)
  - [SQL](#sql)

## Makefile

Makefiles are provided to make builds easier to execute.

To use the [Makefile](../Makefile) a `.env` file is required at the root of this repository. This can be created from [example.env](../.example.env) via `cp .example.env .env` and updating the env variables to match your settings.

The Makefile is self documented and you can view a description of each of the make targets by running `make help` or `make`.

## Poetry - dependency manager

All requirements are managed by Poetry. To install the correct version of Poetry and install the dbt requirements locally run:
1. Install Poetry via `make poetry-install` 
2. Install requirements via `make poetry-requirements`

Note: 
- A virtual environment should **NOT** be used when installing the requirements as this can cause conflicts with Poetry's virtual environment
- Installing the requirements will create Poetry's virtual environment in a folder called `.venv`
- Drone uses the `.venv` file for caching via [drone-s3cache](https://github.com/robertstettner/drone-s3cache)

To add new requirements:
1. Add requirements to [pyproject.toml](../pyproject.toml)
2. Update poetry's lock file via `make poetry-update`
3. Install the requirements with `make poetry-requirements` locally to make sure the build succeeds

## Docker

For production, it's necessary to create the following named volumes:

`docker volume create redditpgdata` - used to persist airflow postgres data

## Postgres

To build the Postgres database, docker is required.

### Building the image

```bash
make pg-build
```

### Running Postgres

To run Postgres locally using the [docker-compose.yml](../postgres/docker-compose.yml) file:

```bash
make run-services-local
```

In production, the volumes are managed by Docker and an optimized
set of configuration parameters need to be defined in [postgres-prod.conf](../postgres/postgres-prod.conf).
These configurations are managed by the [docker-compose.prod.yml](../postgres/docker-compose.prod.yml) file which, overrides the
relevant sections in the [docker-compose.yml](../postgres/docker-compose.yml) file. 

To run in production:

```bash
make run-services-prod
```

Note:
- ensure the above commands are executed within the [root of the repository](../.).
- additional helper commands are available in the [Makefile](../Makefile) and can be viewed by running `make help` or `make`.

## dbt

dbt can be used locally or within a Docker container.

### local development

To run dbt locally install the requirements via [Poetry](#poetry---dependency-manager).

Create a `profiles.yml` file to enable dbt to connect to the Postgres Database. By default, dbt expects the `profiles.yml` file to be located in your `~/.dbt/` folder.

```yaml
# example ~/.dbt/profiles.yml file
data_engineering:
  target: dev_local
  outputs:
    dev_local:
      type: postgres
      host: localhost
      user: postgress
      pass: <YOUR PASSWORD>
      port: 5432
      dbname: blog_scraper
      schema: blogs_dev
      threads: 4
```

Notes: 
- make sure to update the configuration with your password.
- all dbt commands should be run within the [dbt](../dbt/.) folder.

### docker container

#### Building the image

```bash
make dbt-build
```

#### Running dbt

To run dbt locally using the [docker-compose.yml](../postgres/docker-compose.yml) file:

```bash
make run-dbt-local
```

To serve the dbt documentation and access it at [127.0.0.1:8001/](http://127.0.0.1:8001/):

```bash
make serve-dbt-docs
```

Note:
- ensure the above commands are executed within the [root of the repository](../.).

## Linting

### Python

This project uses black, flake8 and isort to ensure that all our Python code is using the same coding standards and formatting. The CircleCI build will fail if Python files are not formatted correctly. 

The Black andflake8 onfiguration are handled in [pyproject.toml](../pyproject.toml), while the flake8 configuration is handled in [.flake8](../.flake8).

Check python linting

```bash
make lint-python
```

Fix python linting

```bash
make black
make isort
```

### SQL

This project uses sqlfluff to ensure that all SQL code is following the same standards.

The sqlfluff configuration is handled in [pyproject.toml](../pyproject.toml).

Check sql linting

```bash
make lint-sql
```

Fix sql linting

```bash
make sqlfluff
```
