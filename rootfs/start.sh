#!/usr/bin/env bash

MC_PROC=server.jar

# Fix owner
bash /etc/my_runalways/00_minecraft_owner

# Create a JAR (can't be ditributed in an image for legal reasons)
bash /etc/init.d/minecraft_server create $MC_VER

# Pass EULA value
bash /etc/my_runalways/90_eula

if [ -z "$MC_MAXMEM" ]; then
  MC_MAXMEM="1G"
fi

if [ -z  "$MC_MINMEM" ]; then
  MC_MINMEM=$MC_MAXMEM ;
fi


MC_JAVA_OPS="-Xmx$MC_MAXMEM -Xms$MC_MINMEM"   # java options for minecraft server

# Start the server, passing additional arguments if needed
java $MC_JAVA_OPS -jar $MC_HOME/$MC_PROC nogui "$@"