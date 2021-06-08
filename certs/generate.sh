#!/bin/bash

# exit when any command fails
set -e

# (optional) environment variable arguments
export PASSPHRASE=123456
export SSL_SUBJECT=${SSL_SUBJECT:-"localhost"}
export SSL_CONFIG=${SSL_CONFIG:-"openssl.conf"}

# SSL config file
echo "====> Generating new config file ${SSL_CONFIG}"
cat > ${SSL_CONFIG} <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
EOM

# Rucio Certficate Authority (CA)
openssl genrsa -out rucio_ca.key.pem -passout env:PASSPHRASE 2048

openssl req -x509 -new -batch -key rucio_ca.key.pem -days 9999 -out rucio_ca.pem -subj "/CN=Rucio CA" -passin env:PASSPHRASE

hash=$(openssl x509 -noout -hash -in rucio_ca.pem)
ln -sf rucio_ca.pem $hash.0

# Issue cluster keys and certificates
for SSL_NAME in rucio fts xrd1 xrd2 xrd3 xrd4 minio
do
    echo "====> Generating new SSL CSR for ${SSL_NAME}"
    openssl req \
        -new \
        -newkey rsa:2048 \
        -nodes \
        -keyout hostcert_${SSL_NAME}.key.pem \
        -subj "/CN=${SSL_SUBJECT}" \
        -config ${SSL_CONFIG} > hostcert_${SSL_NAME}.csr

    echo "====> Generating new SSL CERT for ${SSL_NAME}"
    openssl x509 \
        -req \
        -days 9999 \
        -CAcreateserial \
        -in hostcert_${SSL_NAME}.csr \
        -CA rucio_ca.pem \
        -CAkey rucio_ca.key.pem \
        -out hostcert_${SSL_NAME}.pem \
        -passin env:PASSPHRASE \
        -extensions v3_req \
        -extfile ${SSL_CONFIG}
done


# Issue client key and certificate
openssl req \
    -new \
    -newkey \
    rsa:2048 \
    -nodes \
    -keyout ruciouser.key.pem \
    -subj "/CN=${SSL_SUBJECT}" \
    -config ${SSL_CONFIG}> ruciouser.csr

openssl x509 \
    -req \
    -days 9999 \
    -CAcreateserial \
    -in ruciouser.csr \
    -CA rucio_ca.pem \
    -CAkey rucio_ca.key.pem \
    -out ruciouser.pem \
    -passin env:PASSPHRASE \
    -extensions v3_req \
    -extfile ${SSL_CONFIG}

chmod 0400 *key*

echo
echo "cp rucio_ca.pem /etc/grid-security/certificates/$hash.0"
echo
