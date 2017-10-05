# Minio

[Minio](https://www.minio.io/) is a distributed object storage server built for cloud applications and devops.
To use minio in distributed mode and have redundancy there are some pre-requisites. To understand them you should read the [distributed minio quickstart guide](https://docs.minio.io/docs/distributed-minio-quickstart-guide).
Before you set a minio cluster, make sure you set minio global variables using the template under *vars/*.
Once initialized a web GUI will be available at *http://${CLUSTER_NAME}0.${HOST_DOMAIN}:9091*, or any other host part of the *minio* group.

For unit tests please read the README under *roles/minio/tests/*.

