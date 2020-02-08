# Overview
Docker compose is a container orchestration tool. You use a yaml file to define run parameters and dependencies for docker images.

# install docker-compose
For ubuntu do this
~~~~
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose 
~~~~

# building your docker-compose file
See `docker-compose.yml` file for inline comments.<br>

## environment variables as a file
We are using environment variables as a file in this project.<br>
Very nifty way of putting it all in source control.<br>
Note how the `COMPOSE_PROJECT_NAME=web2` variable is defining the name for any builds in our project. This is way better than the default naming convention of the full path, or something horrible like that.

# build with docker-compose
Issue builds from the defauly docker-compose.yml file with `docker-compose build`.<br>
You can use --file \<file\> if you want to use a file in another directory or a file with a different name.
~~~~
# executes your orchestration
docker-compose build
redis uses an image, skipping
Building web
Step 1/12 : FROM python:3.7.5-alpine
~~~~
Note how our web image was built by this orchestration and we can see it in our current images.<br>
It should be named with the docker_compose project name followed by the image name.
~~~~
docker image ls           
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
web2_web            latest              c0b7061c4d1c        3 minutes ago       109MB
~~~~

# pull with docker-compose
Next, we need to pull down any images we defined to be from dockerhub. We do this with `docker-compose pull`
~~~~
# pull down images from remote registries.
# we already have the "web" image here locally and it said "done" straight away.
docker-compose pull 
Pulling redis ... done
Pulling web   ... done
~~~~

# start the docker-compose project
We can start the project with `docker-compose up`
~~~~
# start our project
docker-compose up  
Creating network "web2_default" with the default driver
Creating web2_redis_1_803445220df0 ... done
Creating web2_web_1_3fc7129b3ee6   ... done
Attaching to web2_redis_1_24a50d346255, web2_web_1_c960f7d45926
~~~~

## start project and build automatically
As expected you can combine the `build` and `up` in one command. To do this, issue the `docker-compose up --build` command.
~~~~
# build and up at the same time, and detach to put in background
docker-compose up --build -d
~~~~

# monitor your compose services
You can see what's running with `docker-compose ps`
~~~~
docker-compose ps           
          Name                         Command               State           Ports         
-------------------------------------------------------------------------------------------
web2_redis_1_24a50d346255   docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
web2_web_1_c960f7d45926     /docker-entrypoint.sh /bin ...   Up      0.0.0.0:5000->5000/tcp
~~~~
You can of course see the containers in the normal `docker container ls` output as well.

# view logs from your compose environment
utilise `docker-compose logs -f` to get the combined logs from all containers in the project.
~~~~
docker-compose logs -f
~~~~

# restart your project
restart your whole project with `docker-compose restart`.<br>
Alternatively you can restart a single container with `docker-compose restart [container name/id]`
~~~~
# restart the whole project
docker-compose restart
Restarting web2_web_1_c960f7d45926   ... done
Restarting web2_redis_1_24a50d346255 ... done

# restart just one service
docker-compose restart web  
Restarting web2_web_1_c960f7d45926 ... done
~~~~

# bespoke exec commands
You can just like in normal `docker run` you can exec a bespoke command with `docker-compose exec [container name/id] [command]`. <br>
You don't need to give the --interactive or --tty flags here as docker-compose adds them automatically.
~~~~
docker-compose exec web ls -la
total 132
drwxr-xr-x    4 1000     ping          4096 Feb  7 23:36 .
drwxr-xr-x    1 root     root          4096 Feb  8 00:23 ..
~~~~

# stop docker-compose containers
You can stop containers with the `docker-compose stop` command.
~~~~
docker-compose stop           
Stopping web2_web_1_c960f7d45926   ... done
Stopping web2_redis_1_24a50d346255 ... done

~~~~

# remove docker-compose containers
To remove the stoppped containers you can use the `docker-compose rm` command.
~~~~
docker-compose rm         
Going to remove web2_web_1_c960f7d45926, web2_redis_1_24a50d346255
Are you sure? [yN] y
Removing web2_web_1_c960f7d45926   ... done
Removing web2_redis_1_24a50d346255 ... done
~~~~