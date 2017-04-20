#!/bin/bash
. env_linux.sh

echo -n setx: HOST_NAME: $HOST_NAME
setx.exe HOST_NAME $HOST_NAME

echo -n setx: HOST_DOMAIN: $HOST_DOMAIN
setx.exe HOST_DOMAIN $HOST_DOMAIN

echo -n setx: NUM_HOSTS: $NUM_HOSTS
setx.exe NUM_HOSTS $NUM_HOSTS

echo -n setx: VAGRANT_HOME: $VAGRANT_HOME
setx.exe VAGRANT_HOME $VAGRANT_HOME 
