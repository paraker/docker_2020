# docker help
Management commands are the most used commands.
~~~~
docker --help
~~~~

# docker build
Builds a docker image with the tag web1 in the current directory
~~~~
# short version
docker build -t web1 . 

# long version
docker image build -t web1 .
~~~~

This will result in a verbose build where we can see each layer being built.