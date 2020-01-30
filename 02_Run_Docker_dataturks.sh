#!/bin/bash
docker pull klimentij/dataturks:latest
docker run -d --rm --name dataturks    -p 8001:80 klimentij/dataturks
