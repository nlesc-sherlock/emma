#!/bin/bash
. env_linux.sh

echo -n setx: CLUSTER_NAME: $CLUSTER_NAME
setx.exe CLUSTER_NAME $CLUSTER_NAME

echo -n setx: HOST_DOMAIN: $HOST_DOMAIN
setx.exe HOST_DOMAIN $HOST_DOMAIN

echo -n setx: NUM_HOSTS: $NUM_HOSTS
setx.exe NUM_HOSTS $NUM_HOSTS

echo -n setx: MEM_SIZE: $MEM_SIZE
setx.exe MEM_SIZE $MEM_SIZE

echo -n setx: VAGRANT_HOME: $VAGRANT_HOME
setx.exe VAGRANT_HOME $VAGRANT_HOME 
