# overview
Connects flask frontend with redis backend across a bridged network

# redis container for backend
~~~~
# pull latest redis image. Should be a debian buster image
docker pull redis

# run redis image in the background and map ports
docker container run --rm -itd -p 6379:6379 --name redis redis
~~~~

# flask container for frontend
~~~~
# build the image with Dockerfile
docker image build -t web2 .

# start flask container with mapped ports
docker container run --rm -itd -p 5000:5000 -e FLASK_APP=app.py -e FLASK_DEBUG=1 --name web2 -v "$PWD:/app" web2
~~~~

# docker networks
Check out the currently available docker networks through `docker network ls`
~~~~
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
b4c022eedc04        bridge              bridge              local
3125d2adc9e0        host                host                local
f93c708a5d50        none                null                local
~~~~
The bridge network is used by default.<br>
You can inspect this network through `docker network inspect bridge`.
~~~~
docker network inspect bridge
        "Containers": {
            "0d6acd6a9a7ec7dcfdc0c12bb63fd7216061fe01d5a5885bcd704691805fff71": {
                "Name": "web2",
                "EndpointID": "9b162b271174c500753aa3df916a41b59a5c7227896844af52251d39e11ee291",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            },
            "f2b5cd870ebc6193cccd17c8f142755675b6808418e35c25ac6cfd5dab18fec9": {
                "Name": "redis",
                "EndpointID": "1ea123a29b660e91f8bdc5ee88f8fcf1794f8fbb7ec9dcc0be6e8d0d0c6f1834",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            }
        },

~~~~
This will among other things list all containers running on this particular network.<br>
In our case we can see both our redis and our flask image.