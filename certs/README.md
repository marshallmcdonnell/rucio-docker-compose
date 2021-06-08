# Certificates for development setup of Rucio cluster and client

This directory holds what is needed to create self-signed certificates.
These are created via the `generate.sh` script.

To create the certificates, provide the `SSL_SUBJECT` to give the IP address for the CA:
```
SSL_SUBJECT=https://0.0.0.0 bash generate.sh
```

Both the `rucio-cluster` and `rucio-client` use the `X509_CERT_DIR` environment variable
to point to these certificates.
