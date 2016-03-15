#!/bin/bash

echo "Clone git repository"
git clone https://5add9ecdab5aebd839ac6c1f18668fb8817f28c9@github.com/seqvence/docker-bday-orchestration.git \
/root/docker-bday-orchestration

echo "Set environment for MongoDB nodes IP addresses"
export mongo0=dbm0.do.lab.seqvence.com
export mongo1=dbm1.do.lab.seqvence.com
export mongo2=dbm2.do.lab.seqvence.com

echo "Change permissions for mongo-key"
chmod 600

