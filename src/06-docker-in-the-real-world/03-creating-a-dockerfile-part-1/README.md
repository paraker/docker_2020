# docker help
Management commands are the most used commands.
~~~~
docker --help
~~~~

# Dockerfile
see Dockerfile for inline documentation

# docker build
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

## Inspect your build
You can print information about your build with `docker image inspect <repo>`
~~~~
docker image inspect web1
~~~~
This will for example show:
* All tags of this particular image (if an image has multiple tags)
* Docker version this was built in
* The layers' full hash values
* The CMD (i.e. the command that will be run)

# docker push
Before you can push to a location, you need to authenticate to it with docker login [your repo]
~~~~
docker image tag web1 paak/web1:latest
~~~~