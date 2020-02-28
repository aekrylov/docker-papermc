#!/usr/bin/env bash

set -e

MC_PROC=server.jar

# Fix owner
bash /check_minecraft_owner.sh

# Create a JAR (can't be ditributed in an image for legal reasons)
bash /minecraft_server create $MC_VER

# Pass EULA value
bash /check_eula.sh

if [ -z "$MC_MAXMEM" ]; then
  MC_MAXMEM="1G"
fi

if [ -z  "$MC_MINMEM" ]; then
  MC_MINMEM=$MC_MAXMEM ;
fi

MC_JAVA_OPS="-Xmx$MC_MAXMEM -Xms$MC_MINMEM"   # java options for minecraft server

# Start the server, passing additional arguments if needed
java $MC_JAVA_OPS -jar $MC_HOME/$MC_PROC nogui "$@"