#!/bin/sh

cp hosts.template hosts
sed -i 's/emma/'"$CLUSTER_NAME"'/g' hosts
sed -i 's/<domain to use>/'"$HOST_DOMAIN"'/g' hosts
