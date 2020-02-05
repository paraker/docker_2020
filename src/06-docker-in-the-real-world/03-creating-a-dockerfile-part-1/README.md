# Dockerfile
see Dockerfile for inline documentation

# docker build
## build your build
Builds a docker image with the repo web1 in the current directory. Note how tags for the repo are set with repo:tag!
~~~~
# short version
docker build -t web1 . 

# long version
docker image build -t web1 .

# with a tag version
docker build -t web1:mytag .
~~~~
This will result in a verbose build where we can see each layer being built.<br>
Note how every command in the Dockerfile translates into its own layer in the build.<br>
~~~~
Step 1/8 : FROM python:3.7.6-alpine
3.7.6-alpine: Pulling from library/python
---
Status: Downloaded newer image for python:3.7.6-alpine
 ---> 6e6836872132
Step 2/8 : RUN mkdir /app
 ---> Running in 8c572d847d47
Removing intermediate container 8c572d847d47
 ---> fc2d251d6f8a
~~~~
Notice how each step has its own hash tied to it. These are the layer hashes used to calculate whether to use cache or if docker has to update the layer.

On a consecutive run we can see how the hash values are the same and cached is used.
~~~
Step 1/8 : FROM python:3.7.6-alpine
 ---> 6e6836872132
Step 2/8 : RUN mkdir /app
 ---> Using cache
 ---> fc2d251d6f8a
~~~~
If a layer changes, every layer after that layer that was changed is rebuilt too, without using cache.

## inspect your build
You can print information about your build with `docker image inspect <repo>`
~~~~
docker image inspect web1
~~~~
This will for example show:
* All tags of this particular image (if an image has multiple tags)
* Docker version this was built in
* The layers' full hash values
* The CMD (i.e. the command that will be run)
* The network configuration, i.e. bridged or overlay

## delete your build
You can delete a single image by referring to the image name or the image id
~~~~
# repo version
docker image rm web1

# id version
docker image rm 8ca3c1d726bd 
~~~~
In our dockerhub example we have the same image hash locally as remote. What if we want to delete both of them at the same time?<br>
Well, you can delete multiple images with the same hash from multiple repos with the --force flag.<br>
Note how this doesn't delete the image from the registry, it only deletes your local image.
~~~~
# Doesn't work unforced
docker image rm 450c181ac5eb        
Error response from daemon: conflict: unable to delete 450c181ac5eb (must be forced) - image is referenced in multiple repositories

# Works with force
docker image rm --force 450c181ac5eb
Untagged: web1:latest
Untagged: paak/web1:latest
Untagged: paak/web1@sha256:5aa1ed36b047ed12c5ac8d4bf1d3637552eb494be6cb00d8b733f13e79537468
Deleted: sha256:450c181ac5ebb685f6b61015c54a9a2b7968a96326e278711135a8d8c9305b02
Deleted: sha256:108985979a09137089460c5f4cf490a7e7df228fbf24b87b7e828e35a19e4d5e
Deleted: sha256:b9232a46619cf200a86eeed524c33f99346d5379c00e68c93d91b8a278dd04f8
Deleted: sha256:5529e9a6a04329b02e9ff99af6fdb2c3ac26eb4d4a946c1d50235e9966852e3d

~~~~

# docker tag
For dockerhub, you need to tag your image with your username/reponame:tag<br>
I think the same applies to AWS ECR as well.
~~~~
# add tag "paak/web1:latest" to image web1
docker image tag web1 paak/web1:latest
~~~~
In my case, the image then lands at [my dockerhub page](https://hub.docker.com/r/paak/)

You can't remove a tag, but you can change tags on images if you want.
~~~~
# changes tag from "paak/web1:latest" to "web1:latest"
docker image tag paak/web1:latest web1:latest
~~~~

# docker push
Before you can push to a registry, you need to authenticate to the registry with docker login [your repo].
~~~~
# Docker assumes dockerhub if you don't specify a registry
docker login 
~~~~
Then push
~~~~
docker push paak/web1:latest
~~~~
We can view my image at [my dockerhub page](https://hub.docker.com/r/paak/)

# docker run
## run containers
`--interactive` `--tty` or `-it` enables Ctrl-C sequence, terminal colours and interactivity.<br>
`--rm` automatically removes the container when it exits.<br>
`--env` or `-e` passes in environment variables<br>
`--name` names your container. If this isn't supplied, docker will generate a name for you.<br>
`--detach` or `-d` runs the container in the background and just prints a container id to standard out.<br>
`--restart on-failure[:max-retries] / always` automatically restarts the container if it would fail. This conflicts with the `--rm` flag.
`--volume "local dir:container dir"` or `-v` mounts a persistent host volume. Used for quick development purposes only. Note that syntax changes per OS! for MacOS the quotes are mandatory. For linux they are not. Windows needs full busybox style path like `/c/Users/USER_NAME/workspace/your_app_dir`
~~~~
# long version
docker container run --interactive --tty --publish 5000:5000 --name my_flask_app --rm --env FLASK_APP=app.py web1

# short version
docker container run -it -p 5000:5000 --name my_flask_app --rm -e FLASK_APP=app.py web1

# run container in background
docker container run --interactive --tty --publish 5000:5000 --name my_flask_app --rm --env FLASK_APP=app.py --detach web1

# run container in background short version
docker container run -itd -p 5000:5000 --name my_flask_app --rm -e FLASK_APP=app.py web1

# run container with volume
docker container run --interactive --tty --publish 5000:5000 --name my_flask_app --rm --env FLASK_APP=app.py --env FLASK_DEBUG=1 --volume "$PWD:/app" --detach web1
~~~~

# view containers
Utilise the `docker container ls -a` command to view all running and stopped containers.<br>
Note how the stopped containers don't consume much space, but it's nice to have it tidy, so do utilise the `--rm` flag when running an image to not have exited containers lying around.
~~~~
docker container ls -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                    PORTS                    NAMES
477f07cdcff4        web1                "/bin/sh -c 'flask r…"   15 seconds ago      Up 14 seconds             0.0.0.0:5000->5000/tcp   my_flask_app
03c371f26868        hello-world         "/hello"                 40 hours ago        Exited (0) 40 hours ago                            focused_lichterman
~~~~

## view logs from containers 
You can see what's happening or what has happened in a container that is running in the foreground, that is detached, or that has exited.<br>
Issue the `docker container logs [container name/id]`<br>
Add `-f` to "tail -f" the log.
~~~~
docker container logs -f my_flask_app
 * Serving Flask app "app.py"
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
~~~~

## view resource usage of your containers
You can get realtime stats of your container by issuing the command `docker container stats` for all containers, or docker `container stats [container name/id]` for a specific container.
~~~~
docker container stats my_flask_app
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
d843c9e35be6        my_flask_app        0.01%               20.66MiB / 15.11GiB   0.13%               2.98kB / 0B         0B / 0B             1

~~~~

## view container specs
To get detailed info from running containers you can issue `docker container inspect [container name/id]`.
This give you details such as:
* volume mounts
* port bindings
~~~~
docker container inspect my_flask_app 
---
"Mounts": [
    {
        "Type": "bind",
        "Source": "/home/paak/workspace/training/docker_2020/src/06-docker-in-the-real-world/03-creating-a-dockerfile-part-1",
        "Destination": "/app",
        "Mode": "",
        "RW": true,
        "Propagation": "rprivate"
    }
],
~~~~

# connecting to containers
To connect to a running container you can run the `docker container exec --interactive --tty [container name/id] [command]` command. Where `command` is what you want to execute.

~~~~
# run a shell in an alpine container called web_1
docker container exec --interactive --tty web_1 sh
# exit with Ctrl-D
~~~~

# stopping containers
To stop your containers you can run`docker container stop [container name/id]`.<br>
Depending on the `--rm` or the `--restart` flag settings, the container will either be deleted or exited.<br>
NOTE: The manual stop of a container will NOT trigger a restart even if the `--restart` policy is set.<br>
This is because you manuall intended to stop the image.<br>
However, an event like you shutting down the docker service will indeed restart the container.
~~~~
docker container stop my_flask_app 
~~~~

# delete containers
If you do happen to have containers you want to delete you can issue `docker container rm [name or id]` to remove them.
~~~~
docker container rm focused_lichterman 
focused_lichterman
~~~~

# Container modifications
## production deployments
Your source code should be in version control. The source code should be copied while building images in a lifecycle process and with ci/cd.

See `Dockerfile` and `docker build` topics in this readme to declare and build your image.

## development deployments
To quickly be able to reiterate over docker builds you may edit containers as they are running.<br>

By edit the containers we refer to mounting a `volume` containing the source code to our app.<br>
Modifications to the volume are happening live in the running container (well, with caveats depending on distro, for example [alpine linux's inotifyd](https://wiki.alpinelinux.org/wiki/Inotifyd)'s issues with virtualbox and hyperv')<br>
This volume is persistent to the `docker host` and circumvents the idempotence of the container.<br>

### mount volumes

### user/group for files written to disk (linux only)
Say that you mount volumes on linux and create files through `docker exec`. By default, this will resort to the `root` user in the container's user space.<br>
As such, you may end up witf files owned by `root` on your local disk.<br>

~~~~
# create test.txt as default user (root)
docker container exec --interactive --tty app_1 touch test.txt

ll
-rw-r--r-- 1 root root      0 Feb  5 16:12 test.txt

~~~~
Instead, we can use the `--user` flag to create files with a specified user.
~~~~
# execute commands with the logged in user and that user's group id
docker container exec --interactive --tty --user "$(id -u):$(id -g)" app_1 touch test.txt

~~~~

# Troubleshooting
## see what's going on - docker exec
See "connecting to containers" section in this readme.

## base image for Desktop OS development
For local tinkering with docker containers do note that alpine linux is super slim and its kernel modules are made for linux primarily.<br>
If you're running into issues such as file system changes not appearing, you may change to a more friendly linux distro as your base image.<br>
Most official images have a few options, so go ahead and test ubuntu, slim (Debian) or the like.<br>
These may work better with Virtualbox, HyperV and Hyperkit.