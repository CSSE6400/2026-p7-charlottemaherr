FROM ubuntu:latest

ENV SQLALCHEMY_DATABASE_URI=sqlite:///:memory:

# Installing dependencies and cleaning up
RUN apt-get update && \
        apt-get install -y python3 pipx postgresql-client libpq-dev libcurl4-openssl-dev libssl-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
RUN pipx ensurepath

# Install poetry in a virtual environment
RUN pipx install poetry

# Set the working directory
WORKDIR /app

# Install poetry dependencies
COPY pyproject.toml .
RUN pipx run poetry install --no-root

# Copy our application into the container
COPY bin bin
COPY todo todo

# Run our application
ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["serve"]
