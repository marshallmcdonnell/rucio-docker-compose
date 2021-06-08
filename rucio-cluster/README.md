# Rucio cluster via Docker

This contains the docker setup for a Rucio cluster.

The cluster requires SSL so certificates are required for the services.
These are currently stored in the `certs` directory.
These certificates are mounted in as volumes to the docker containers.
Use the `X509_CERT_DIR` to pass in the path to the certificates directory.

### Quickstart

To start the Rucio cluster, run:

```
X509_CERT_DIR=../certs docker-compose  up
```

Then, use the `rucio-client` to run the client to interact with the cluster.

To spin down the cluster run
```
docker-compose down
```

### Details of cluster

Containers have different purposes, some services and some are "bootstrappers":

| Container Name  | Purpose                                                    |
|-----------------|------------------------------------------------------------|
| `rucio-db`      | Rucio PostgreSQLDatabase for auth / authz data             |
| `rucio-db-init` | Bootstraps `rucio-db` container (creates db, tables, etc.) |
| `rucio`         | Rucio server for API / backend                             |
| `rucio-ui`      | Rucio UI / frontend                                        |
| `graphite`      | Graphite service for monitoring                            |
| `fts`           | File Transfer Service                                      |
| `ftsdb`         | File Transfer Service MySQL Database                       |
| `xrd1`          | XRootD storage                                             |
| `xrd2`          | XRootD storage                                             |
| `xrd3`          | XRootD storage                                             |
| `xrd4`          | XRootD storage                                             |
| `minio`         | MinIO object storage                                       |

Services are located on the following ports:

| Host Port | Container Port | Purpose                                        |
|-----------|----------------|------------------------------------------------|
| 8443      | 443            | Rucio Server API port                          |
| 443       | 443            | Rucio UI (currently, not working)              |
| 8446      | 8446           | File Transfer Service (FTS) port               |
| 8449      | 8449           | File Transfer Service (FTS) port               |
| 3306      | 3306           | File Transfer Service (FTS) database port      |
| 1094      | 1094           | XRootD storage (XRD1)                          |
| 1095      | 1095           | XRootD storage (XRD2)                          |
| 1096      | 1096           | XRootD storage (XRD3)                          |
| 1097      | 1097           | XRootD storage (XRD4)                          |
| 9000      | 9000           | MinIO Object Storage service port              |
| 8080      | 80             | Graphite UI                                    |

