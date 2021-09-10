#!/bin/bash
set -x;

docker build -t azuresdk/autorest ./base/ubuntu
docker build -t azuresdk/autorest-dotnet ./dotnet/ubuntu
