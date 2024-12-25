#!/bin/bash

docker stop currency-converter-app
docker rm currency-converter-app

docker run -d -p 3000:3000 --name currency-converter-app currency-converter-app:1.0