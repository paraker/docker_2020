## Pull an image
docker pull image:tag
docker cli is smart enough to fill in the URL to dockerhub by itself.
You can use the short syntax of just:

	docker pull hello-world

Or you can list the repo at dockerhub, like this: 

	docker pull docker.io/library/hello-world

## Running an image
~~~~
docker run --rm -it 
~~~~

## Dockerfile
The Dockerfile is sort of equivalent to a requirements.txt. <br>
It's something that defines dependencies in one place and it can be version controlled.

## Docker Image
A docker image consists of layers.<br>
Build and pull understands these layers and will only update the ones that are required (if cache is enabled).

## Docker Registry and dockerhub
Contains multiple docker repositories

Each repo contains multiple images

Each docker image is defined by tags.

Official repos at dockerhub are managed by Docker. These images are all scanned by Docker. You can see all vulnerabilties on their site.

