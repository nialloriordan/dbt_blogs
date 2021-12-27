FROM postgres:14.1

# Install python3
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    postgresql-plpython3-14

# Python ML requirements
RUN pip install pandas==1.3.5 \
    torch==1.10.1 \
    torchvision==0.11.2 \
    transformers==4.14.1

# Add root folder folder to python path
ENV PYTHONPATH /:${PYTHONPATH}

# Load Zero Shot Model
COPY scripts/python /zero_shot
RUN python3 -m zero_shot.save_pretrained_zero_shot -c /zero_shot/config.yml

# Intitalise DB
COPY scripts/sql/ /docker-entrypoint-initdb.d/
ENV PGDATA=/data
EXPOSE 5432
