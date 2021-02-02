#! /bin/bash

set -ex

BASEDIR=$(realpath "$(dirname $0)/../../")

docker build -t autrestdevsetup .
docker run \
    --rm \
    --volume $BASEDIR:/autorest \
    -it \
    autrestdevsetup