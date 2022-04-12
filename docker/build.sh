#!/bin/bash
set -x;

docker build -t azuresdk/autorest ./base/ubuntu
docker build -t azuresdk/autorest-dotnet ./dotnet/ubuntu
docker build -t azuresdk/autorest-python ./python/ubuntu
docker build -t azuresdk/autorest-java ./java/ubuntu

docker build -t azuresdk/autorest-all ./all/ubuntu
