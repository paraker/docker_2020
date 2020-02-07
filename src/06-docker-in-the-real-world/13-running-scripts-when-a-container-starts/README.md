# overview
How to run a script when container starts.<br>
Note that entrypoints do not rebuild your images as they are executed *after* the image is built!<br>
Sort of like userdata can be used for ec2.

# because it scales
Say that you have 1 image that will be used by many projects.<br>
Say you wanted to build a postgres db and users in your image. But the db was to be used by 5 different web apps. Hence, the startup script to create the db and the users would be different.<br>
You can at that point create a separate Dockerfile for each web app project. But repitition stinks.<br>

What you instead want to utilise is the `ENTRYPOINT` in the postgres official image.<br>
The `ENTRYPOINT` is a shell script with complicated logic in it. This script accepts environment variables that you can pass in to the image when you run it.

# basic usage
This is basic usage of an `ENTRYPOINT`
~~~~
# Dockerfile code for ENTRYPOINT script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
~~~~

# build and test
## basic test
Build the image to start with from the `Dockerfile` that includes the entrypoint
~~~~
docker image build -t entrypoint .
~~~~
Now run the image in the foreground.
~~~~
 docker container run --rm -it -p 5000:5000 -e FLASK_APP=app.py -e FLASK_DEBUG=1 --name entrypoint --network mynetwork entrypoint
~~~~
You will see that the entrypoint has been executed.<br>

## pass variable to entrypoint
~~~~
docker container run --rm -it -p 5000:5000 -e FLASK_APP=app.py -e FLASK_DEBUG=1 --name entrypoint -e WEB2_COUNTER_MSG="Docker fans have visited this page" --network mynetwork entrypoint
~~~~

# understand CMD
## default entrypoint
The default entrypoint for CMD is `/bin/sh -c` <br>

`CMD` instruction is passed in as an arugment to the entrypoint script (default or bespoke).<br>

So for a default entrypoint it is like this:<br>
`bin/sh -c [CMD]`<br>

So for our `Dockerfile`'s `CMD` it looks like this with a default entrypoint.
~~~~
# in dockerfile
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

# executed as
/bin/sh -c flask run --host=0.0.0.0 --port=5000
~~~~
## bespoke entrypoint
When we add a bespoke entrypoint it is added
CMD instruction gets appended to our script
~~~~
# I think this is what happens at least
# entrypoint is used to append the standard /bin/sh -c
# we have two essential lines in the entrypoint script
# one will do an env export, the other will do exec "$@"
/bin/sh -c export WEB2_COUNTER_MSG && exec "$@"

# The "$@" can be expanded to all arguments passed to the entrypoint script, i.e. the CMD arguments and execute them as a single line
/bin/sh -c export WEB2_COUNTER_MSG && exec CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

# Extracted the arguments into the one single command it looks like this
/bin/sh -c export WEB2_COUNTER_MSG && exec "flask run --host=0.0.0.0 --port=5000"
~~~~

## web frontend modifications
This is what makes the web page display what's in the environment variable.
~~~~
def counter():
    return '{0} {1}'.format(str(redis.incr('web2_counter')),
                            os.getenv('WEB2_COUNTER_MSG', ''))
~~~~