# Rucio client for working with Rucio cluster

This repository holds a script to run a Rucio client via a Docker container


### Quickstart

After the Rucio cluster is running and an IP address (w/ port) is ready for the Rucio server,
use that to launch the client from this directory.

You will need the certificates (CA cert, client cert, and client key) which are created
during the cluster provisionin and place them in a directory.

They exist in the `certs/` directory at the top-level of the repository:
```
$ echo $(ls ../certs/ruciouser*.pem) $(ls ../certs/rucio_ca.pem)
../certs/ruciouser.key.pem ../certs/ruciouser.pem ../certs/rucio_ca.pem
```

If the server is running at `localhost` and exposed via port 8443, launch via:

```
X509_CERT_DIR=../certs/ ./rucio-client-docker https://localhost:8443
```

You can also modify the Rucio client configuration by environment variables.
Run the client to get the most up-to-date options.

### Test

You can test if the rucio client works by navigating to the `/test` directory
in the container (which is a volume mount of the `tests/` directory located
in this sub-directory.

This will go through the`k8s-tutorial-test-script.sh` script,
which runs the instructions from the
[Rucio Kubernetes tutorial repository](https://github.com/rucio/k8s-tutorial) README
as a test.

This script is idempotent, so you can run it again (albeit, with warnings)
but you won't continue to change the state of the data in the Rucio cluster.

### Tricks

If you need to check the client configurartion file,
it will be located inside the container at:
  - `/opt/rucio/etc/rucio.cfg`
