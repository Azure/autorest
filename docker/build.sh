#!/bin/bash
set -x;

docker build -t azsdkengsys.azurecr.io/azuresdk/autorest --build-arg REGISTRY="mcr.microsoft.com/mirror/docker/library/" ./base/ubuntu
docker build -t azsdkengsys.azurecr.io/azuresdk/autorest-dotnet ./dotnet/ubuntu
docker build -t azsdkengsys.azurecr.io/azuresdk/autorest-python ./python/ubuntu
docker build -t azsdkengsys.azurecr.io/azuresdk/autorest-java ./java/ubuntu
docker build -t azsdkengsys.azurecr.io/azuresdk/autorest-all ./all/ubuntu
