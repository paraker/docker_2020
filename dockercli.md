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

