# The first uncommented line of a Dockerfile must be "FROM"
# official dockerhub repo = omitted. dockercli assumes this.
# image = python
# tag = 3.7.6-alpine
FROM python:3.7.6-alpine

# RUN lets us run any command or shell script
# Create a folder to store an app
RUN mkdir /app

# Set path for any future commands in this file
# You can use multiple WORKDIR commands in your Dcokerfile if you want
WORKDIR /app

# COPY is similar to cp in linux
# NOTE You can't go above your Dockerfile's directory!
# i.e. you can't run ../requirements.txt
# The below will copy ./requirements.txt to /app/requirements.txt
COPY requirements.txt .
# Full paths works as well of course, like:
# COPY requirements.txt /app/requirements.txt

# Run command to install requirements.txt 
RUN pip install -r requirements.txt

# Copy everything from our local directory into /app in the container
# This is to copy all source code into the container.
# This will copy the Dockerfile, the Dockerfile.finished too thought if you were wondering
# It goes into /app because that's our workdir.
COPY . .

# Key and value that can be retrieved later on
# These can be used for filters etc
# key="value". quotes are mandatory around value
# Note how MAINTAINER will be deprecated, so use LABEL for maintainer
# Each label creates a layer, so bunch them up with linux multiline style \
LABEL maintainer="Par Will <par.whatever@whatever.com>" \
	  version="1.0"

# CMD is the command that will be executed when the container is run
# Here we are just executing a flask command to start a web server
CMD flask run --host=0.0.0.0 --port=5000