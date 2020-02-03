# The first uncommented line of a Dockerfile must be "FROM"
FROM python-3.7.5-alpine

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
COPY requirements.txt requirements.txt
# Full paths works as well of course, like:
# COPY requirements.txt /app/requirements.txt

# Run command to install requirements.txt 
RUN pip install -r requirements.txt

# Copy everything from our local directory into /app in the container
# This will copy the Dockerfile, the Dockerfile.finished etc
# It goes into /app because that's our workdir.
COPY . .