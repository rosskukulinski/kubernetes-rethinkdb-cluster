#!/bin/bash		

# Fail with first error
set -e

# Checks if the rethinkdb instance is ready to operate.
# This will be used to direct client traffic
# And, more instances will not be created by the petset until it returns success.

# For now, try to hit the app at 8080
curl localhost:8080
