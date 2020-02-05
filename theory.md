### Why Docker?
Save money by reducing footprint.<br>
Speed through provisioning less.<br>
Gets rid of "it works on my laptop" through packaging.<br>

### Docker CE / EE
Docker CE is perfectly fine for production.

The differentiator that Docker EE has is ability to use a scan when you build your images and access to Docker Data Centre (perhaps that's like a VPS solution?).

### Docker Toolbox
Docker Toolbox is old school for macos/win.<br>
It contains virtualbox and runs a few tools in addition to docker for win/mac.

### Docker for Win/Mac
Docker for win/mac requires a hypervisor in the OS.<br>
For mac that is hyperkit, for windows it's hyperv.

### Versioning format and release cycles
v19.10 = year 2019, month October.<br>
There's a stable release every quarter and a latest release every month.

### Docker image
Never changes! Once it is built, it stays that way.<br>
This is a class in the programming world.<br>
A docker image consists of layers.<br>
Build and pull understands these layers and will only update the ones that are required (if cache is enabled).

### Docker container
A running image. These are immutable, i.e. changes are not persistent. (well, you can make them non immutable through volumes). <br>
This is an instance of a class in the programming world.

### Dockerfile
It's a run sheet of how your docker images are built.<br>
The Dockerfile is sort of equivalent to a requirements.txt in the python world. <br>
It's something that defines dependencies in one place and it can be version controlled.

### Docker Registry, dockerhub and official repos
Official repos at dockerhub are managed by Docker. These images are all scanned by Docker.<br>
You can see all vulnerabilties on their site.<br>

Explore [official docker images at dockehub](https://hub.docker.com/search?q=&type=image&image_filter=official)
Most official programming language images have these standard base images:<br>
* slim - lightweight linux based on debian:buster
* alpine - super lightweight linux
* buster - debian 10
* stretch - debian 9

### Alpine linux
[Alpine Linux](https://github.com/alpinelinux) is a security-oriented, lightweight Linux distribution based on musl libc and busybox.
