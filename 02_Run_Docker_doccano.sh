#!/bin/bash
docker pull chakkiworks/doccano

# As a one-time setup, create a Docker container for Doccano:

docker pull chakkiworks/doccano
docker container create --name doccano_$(date +%Y_%m_%d) \
  -e "ADMIN_USERNAME=admin" \
  -e "ADMIN_EMAIL=admin@example.com" \
  -e "ADMIN_PASSWORD=password" \
  -p 8000:8000 chakkiworks/doccano

# Next, start Doccano by running the container:

docker container start doccano_$(date +%Y_%m_%d)

#To stop the container, run docker container stop doccano -t 5. All data created in the container will persist across restarts.

#Access http://127.0.0.1:8000/.
echo "You can now access it @ http://127.0.0.1:8000/"
