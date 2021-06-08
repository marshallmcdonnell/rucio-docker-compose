# Rucio docker-compose development setup (cluster + client)

**WARNING:** not in a working state!!! This repo is to reproduce my errors while setting up a docker-compose Rucio setup for development.

"[Rucio](https://rucio.cern.ch/) is a software framework that provides functionality to organize, manage, and access large volumes of scientific data using customisable policies." -Rucio website (hyperlink in quote)

Rucio is a data management tool that comes from the high-energy physics community at [CERN](https://home.cern/)
and was part of the [ATLAS experiment](https://atlas.cern/).

This repository containers the following:
  - The Rucio cluster setup via docker-compose (in `rucio-cluster` directory)
  - The Rucio client setup via Docker (in `rucio-client` directory)
  - The certificates for SSL between the Rucio cluster services and Rucio client to API

Each of the sub-directories have README that explain further details of that component.

# Quickstart

1) Generate the self-signed certificates:
```
cd certs/
SSL_SUBJECT=localhost bash generate.sh
cd ../
```

2) Spin up the Rucio cluster via docker-compose
```
cd rucio-cluster
X509_CERT_DIR=../certs docker-compose up
cd ../
```

3) Spin up a Rucio client container
```
cd rucio-client
X509_CERT_DIR=../certs ./rucio-client-docker https://localhost:8443
```

4) Then, from inside the Rucio client container, run the test script:
```
cd /test
bash k8s-tutorial-test-script.sh
```
