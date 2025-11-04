#!/bin/bash

docker build . -t cheese

PASSWORD="cheese"
PORT=8787

docker run \
  -p $PORT:8787 \
  -e PASSWORD=$PASSWORD \
  -v $(pwd):/home/rstudio \
  -it cheese

echo "RStudio Server is running!"
echo "Open http://localhost:$PORT in your browser"
echo "Username: rstudio"
echo "Password: $PASSWORD"

