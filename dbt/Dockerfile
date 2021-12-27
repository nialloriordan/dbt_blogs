FROM python:3.9-slim

# install git - required to install any dbt packages
RUN apt-get update && \
    apt-get install -y \
    git 

# specify custom dbt profiles directory
ENV DBT_PROFILES_DIR /home/dbt_user/dbt_project

# update pip as root user
RUN pip install --upgrade pip

# create new user - dbt_user
RUN useradd --create-home --shell /bin/bash dbt_user
USER dbt_user

# add dbt_user home directory to path
ENV PATH /home/dbt_user/.local/bin:${PATH}

# specify working directory as the dbt project
WORKDIR /home/dbt_user/dbt_project

# install dbt postgres
RUN pip install dbt-postgres==1.0.0

# install dbt dependencies
COPY --chown=dbt_user:dbt_user dbt_project/dbt_project.yml /home/dbt_user/build_dbt_deps/
COPY --chown=dbt_user:dbt_user dbt_project/packages.yml /home/dbt_user/build_dbt_deps/
RUN cd /home/dbt_user/build_dbt_deps && dbt deps
