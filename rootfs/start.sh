#!/usr/bin/env bash

MC_PROC=server.jar

execCMD() {
	# if running as root, switch to defined user
	if [ $(id -u) -eq 0 ]; then
		su -s /bin/sh -c "$1" $MC_USER $2
	else
		sh -c "$1" $2
	fi
}


download() {
  #
  # download Paper jar for requested version, if it doesnt exist already
  #
  if [ ! -f server-$1.jar ]; then
    echo "Downloading JAR for PaperMC v. $1"
    wget https://papermc.io/api/v1/paper/$1/latest/download -O server-$1.jar
  fi
  execCMD "rm -f $MC_HOME/server.jar"
  execCMD "ln -s $MC_HOME/server-$1.jar $MC_HOME/server.jar"
}

check_eula() {
  if [ -z "$EULA" ] ; then
    echo "You have to accept Mojang EULA to run the server. Run with EULA environment variable set to true to accept it."
    echo "EULA text is available at https://account.mojang.com/documents/minecraft_eula"
    exit 1
  fi
}

# Fix owner
bash /check_minecraft_owner.sh

check_eula

# Download Paperclip JAR for specified version
download ${MC_VER:-latest}

# Process memory settings
if [ -z "$MC_MAXMEM" ]; then
  MC_MAXMEM="1G"
fi

if [ -z  "$MC_MINMEM" ]; then
  MC_MINMEM=$MC_MAXMEM ;
fi

MC_JAVA_OPS="-Xmx$MC_MAXMEM -Xms$MC_MINMEM"

# Start the server, passing additional arguments if needed
rm -rf /input.con
touch /input.con
execCMD "tail -f /input.con | java $MC_JAVA_OPS -jar $MC_HOME/$MC_PROC nogui $*" | tee /output.con