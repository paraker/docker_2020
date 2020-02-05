# overview
How to share data between containers *if they are on the same host(!)*

# expose and access container volumes
## expose container volume to other containers
You can choose to expose volumes to other containers by using the `VOLUME` keyword in the `Dockerfile`.<br>
These are linked directly between the containers and do not need to land on the host in the middle.
~~~~
# expose /app/public to other containers
# this will be mounted as /app/public on other containers
VOLUME ["/app/public"]
~~~~
Technically, you don't have to edit the `Dockerfile` to expose a `VOLUME`. <br>
However, it is considered best practice to explicitly state this in your `Dockerfile`.<br>

## access container volume from other containers
You can now use the `--volumes-from [container name/id]` to gain access to the exposed volume.
~~~~
# --volumes-from will be mounted as /app/public
docker container run --rm -itd -p 6379:6379 --name redis --network mynetwork --volume web2_redis:/data --volumes-from web2 redis
~~~~

# build web frontend with exposed volume
Time to build our image, now that we have an exposed volume in the `Dockerfile`.
~~~~
docker image build -t web2 .
---
Step 8/9 : VOLUME ["/app/public"]
 ---> Running in f2b9381ae2f1
Removing intermediate container f2b9381ae2f1
~~~~
We can now load the volume from the backend redis container using the `--volumes-from` variable.
~~~~
docker container run --rm -itd -p 5000:5000 -e FLASK_APP=app.py -e FLASK_DEBUG=1 --name web2 -v "$PWD:/app" --network mynetwork web2 && \
docker container run --rm -itd -p 6379:6379 --name redis --network mynetwork --volume web2_redis:/data --volumes-from web2 redis                   
~~~~

## verify that the volume is mounted
Create a shell in the redis container with `docker exec` and see if the mount /app/public exists.
~~~~
docker exec -it redis sh       
# ls /app/public
main.css

# live add file on other container.
# It's automatically detected by this container.

# ls /app/public/ 
main.css  myfile
~~~~