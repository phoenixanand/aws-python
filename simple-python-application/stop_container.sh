#!/bin/bash
set -e

echo "Checking for running containers..."

containerid=$(docker ps -q)

if [ ! -z "$containerid" ]; then
  echo "Stopping running container..."
  docker stop $containerid
  docker rm $containerid
else
  echo "No running containers found"
fi
