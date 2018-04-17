#!/bin/sh
for f in `ls -1 *.template | sed -e 's/\.template$//'`; do echo "create $f"; cp $f.template $f; done 
