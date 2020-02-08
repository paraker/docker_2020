#!/bin/sh
set -e  # Stops the script if any line failed

echo "The Dockerfile ENTRYPOINT has been executed!"

# export the variable passed in with docker -e ""
export WEB2_COUNTER_MSG="${WEB2_COUNTER_MSG:-carbon based life forms have sensed this website}"

# takes all arguments from CMD and executes them on a single line. See README.md
exec "$@"
