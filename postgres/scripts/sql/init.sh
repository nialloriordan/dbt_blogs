#!/bin/bash
set -e

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION plpython3u;
    CREATE SCHEMA raw_data;
EOSQL
