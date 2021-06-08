# Rucio docker-compose development setup (cluster + client)

"[Rucio](https://rucio.cern.ch/) is a software framework that provides functionality to organize, manage, and access large volumes of scientific data using customisable policies." -Rucio website (hyperlink in quote)

Rucio is a data management tool that comes from the high-energy physics community at [CERN](https://home.cern/)
and was part of the [ATLAS experiment](https://atlas.cern/).

This repository containers the following:
  - The certificates for SSL between the Rucio cluster services and Rucio client to API
  - The Rucio cluster setup via docker-compose (in `rucio-cluster` directory)
  - The Rucio client setup via Docker (in `rucio-client` directory)

Each of the sub-directories have README that explain further details of that component.

# 

:warning: **WARNING:** NOT IN A WORKING STATE!!! 

This repo is to reproduce my errors while setting up a docker-compose Rucio setup for development.

Following the ["Quickstart"](#quickstart) steps below, the current error is during file upload in the `rucio-client/test/k8s-tutorial-test-script.sh`:

 - *Commands*:
```
rucio upload --rse XRD1 --scope test file1
rucio upload --rse XRD1 --scope test file2
rucio upload --rse XRD2 --scope test file3
rucio upload --rse XRD2 --scope test file4
```

 - *Output*:
```
2021-06-08 15:59:20,424	ERROR	The requested service is not available at the moment.
Details: An unknown exception occurred.
Details: Failed to stat file (No route to host)
2021-06-08 15:59:22,275	ERROR	The requested service is not available at the moment.
Details: An unknown exception occurred.
Details: Failed to stat file (No route to host)
2021-06-08 15:59:23,805	ERROR	The requested service is not available at the moment.
Details: An unknown exception occurred.
Details: Failed to stat file (No route to host)
2021-06-08 15:59:25,443	ERROR	The requested service is not available at the moment.
Details: An unknown exception occurred.
Details: Failed to stat file (No route to host)
```

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
