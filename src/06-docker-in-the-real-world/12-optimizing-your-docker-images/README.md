# Overview
Shrink and secure your docker images

# .dockerignore file
You can omit files from reaching containers in `COPY` / `ADD` instructions in your `Dockerfile`.<br>
`WORKDIR` is used to determine where the `.dockerignore` file looks for files to ignore.<br>

# optimise Dockerfile
Alpine linux uses build dependencies during package adds.<br>
These are not needed post the installation and can safely be deleted.<br>
See the Dockerfile in this directory for an example of a space efficient add of packages to alpine.

pros:<br>
You get smaller images

cons:<br>
you will rebuild from an early layer in your build<br>
complicates your `Dockerfile`<br>