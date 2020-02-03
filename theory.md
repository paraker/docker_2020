### Why Docker?
Save money by reducing footprint.
Speed through provisioning less
Gets rid of "it works on my laptop" through packaging

### Docker CE / EE
Docker CE is perfectly fine for production.

The differentiator that Docker EE has is ability to use a scan when you build your images and access to Docker Data Centre (perhaps that's like a VPS solution?).

### Docker Toolbox
Docker Toolbox is old school for macos/win.

It contains virtualbox and runs a few tools in addition to docker for win/mac.

### Docker for Win/Mac
Docker for win/mac requires a hypervisor in the OS.

For mac that is hyperkit, for windows it's hyperv.

### Versioning format and release cycles
v19.10 = year 2019, month October 
There's a stable release every quarter and a latest release every month.

### Docker image
Never changes! Once it is built, it stays that way.
This is a class in the programming world.

### Docker container
A running image. These are immutable, i.e. changes are not persistent. (well, you can make them non immutable). <br>
This is an instance of a class in the programming world.

## Dockerfile (blueprint/cookie cutter)
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


