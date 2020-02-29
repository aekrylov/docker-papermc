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
  if [ -z "$1" ] ; then
    echo "Minecraft version must be specified with MC_VER environment variable"
    exit 1
  fi
  if [ ! -f server-$1.jar ]; then
    echo "Downloading JAR for PaperMC v. $1"
    wget https://papermc.io/api/v1/paper/$1/latest/download -O server-$1.jar
  fi
  execCMD "rm -f $MC_HOME/server.jar"
  execCMD "ln -s $MC_HOME/server-$1.jar $MC_HOME/server.jar"
}

check_eula() {
  #
  # accept eula if set
  #
  # (c) 2016 nimmis <kjell.havneskold@gmail.com>

  if [ ! -f $MC_HOME/eula.txt  ] ; then
    echo '#EULA file created by minecraft script\neula=false' > $MC_HOME/eula.txt
  fi

  if [ -n "$EULA" ] ; then
    echo "eula=$EULA" > $MC_HOME/eula.txt
    chown minecraft $MC_HOME/eula.txt
  fi

  if [ `grep eula $MC_HOME/eula.txt |  grep -v 'true'` ] ; then
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

if [ -z "$MC_MINMEM" ]; then
  MC_MINMEM=$MC_MAXMEM ;
fi

JAVA_OPTS="-Xmx$MC_MAXMEM -Xms$MC_MINMEM $JAVA_OPTS"

# Start the server, passing additional arguments if needed
rm -rf /input.con
touch /input.con
execCMD "tail -f /input.con | java $JAVA_OPTS -jar $MC_HOME/$MC_PROC nogui $*" | tee /output.con