# postgres

![circleci][circleci]
Minimal postgresql image

## Usage

Running the image requires only a `PGPASSWORD` variable to be set:
```bash
docker run -d --name=postgres \
           -p 5432:5432 \
           -e PGPASSWORD="<pass>" \
           -v $(pwd):/dbscripts \
           quay.io/vektorcloud/postgres:latest
```

connect locally with:
```bash
docker exec -ti postgres psql
```

## Initialization

A default postgres database will be initialized the first time a container is started.

To include additional `.sql` scripts as part of the initialization step, mount or otherwise include them within the container at `/dbscripts`:
```bash
echo 'CREATE TABLE sweettablebro;' >> mktable.sql
docker run -d --name=postgres \
           -p 5432:5432 \
           -e PGPASSWORD="<pass>" \
           -v $(pwd):/dbscripts \
           quay.io/vektorcloud/postgres:latest
```

[circleci]: https://img.shields.io/circleci/project/github/vektorcloud/postgres.svg "postgres"
