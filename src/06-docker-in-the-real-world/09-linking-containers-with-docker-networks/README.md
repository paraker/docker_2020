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
In our case we can see both our redis and our flask image.<br>
These images can now talk to each other as they live on the same host.

# use dns for local docker instances
Docker can automatically manage dns for you on bridged networks.<br>
To make this happen, all you have to do is create your own bridge network and docker will do the rest.

~~~~
# create a new bridged network
docker network create --driver bridge mynetwork

# stop your containers to take them off the old network
docker container stop web2 redis

# start your containers with `--network mynetwork` variable to move them to the new network
docker container run --rm -itd -p 6379:6379 --name redis --network mynetwork redis
docker container run --rm -itd -p 5000:5000 -e FLASK_APP=app.py -e FLASK_DEBUG=1 --name web2 -v "$PWD:/app" --network mynetwork web2

# inspect to show containers on the network
docker network inspect mynetwork
~~~~

dns reference will now be available in the containers based on the container name.<br>
~~~~
# confirm dns lookups on new network with docker exec
docker exec web2 nslookup redis
Name:	redis
Address: 172.18.0.3
~~~~

# connecting flask to redis
Not part of docker at all, but this is the line in the flask config that connects the flask container to the redis container
~~~~
# reference to the url "redis" created by docker
# redis:// is a sql like connection type
app.config['REDIS_URL'] = 'redis://redis:6379/0'
~~~~

# connect to redis for fun
we can use rediscli to modify our counter value to something arbitrary
~~~~
docker exec -it redis redis-cli
127.0.0.1:6379> KEYS *
1) "web2_counter"
127.0.0.1:6379> INCRBY web2_counter 1000000
(integer) 1000016
~~~~

# named volumes - persist data between container runs
At the moment the app will not save state as the containers are immutable. Once re-run, our simple visit counter starts at 1.<br>
This can be achieved with a `named volume`.<br>
A `named volume` takes to a name as argument instead of a file path in the basic `volume` command.<br>
Docker then manages the rest automatically in its named volumes directory.<br>

~~~~
# create a named docker volume
docker volume create web2_redis
web2_redis

# list available docker volume
docker volume ls
~~~~
We can show details of a volume with `docker volume inspect [volume]`. This gives us details as such where the volume is stored on the host.
~~~~
# show details about a volume
docker volume inspect web2_redis
	"Mountpoint": "/var/lib/docker/volumes/web2_redis/_data",
~~~~
On our linux host in this case, the data is stored on the host in `/var/lib/docker/volumes/`.<br>
In virtualbox setups the volumes should be within virtualbox.

## mount named volume to redis container
use `--volume` to mount the newly created named volume to the redis container.
~~~~
# start both containers again. mount named volume to redis container's /data directory, which is default for redis' data
docker container run --rm -itd -p 6379:6379 --name redis --network mynetwork --volume web2_redis:/data redis && \                   
docker container run --rm -itd -p 5000:5000 -e FLASK_APP=app.py -e FLASK_DEBUG=1 --name web2 -v "$PWD:/app" --network mynetwork web2   

# hit the webpage a couple of times to increase counter

# stop the containers
docker container stop web2 redis

# start containers using the run commands above
# rejoice as your counter is back to where you left it.
~~~~