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
    echo "Downloading Paper version ($1) jar file"
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

  `grep eula $MC_HOME/eula.txt |  grep -v 'true'` && echo "You haven't accepted EULA! run with EULA=true in env to accept" >&2 && exit 1
}

# Fix owner
bash /check_minecraft_owner.sh

# Download Paperclip JAR for specified version
SVER=${MC_VER:-latest}
echo "Setting version to $SVER"
download $SVER

# Pass EULA value
check_eula

if [ -z "$MC_MAXMEM" ]; then
  MC_MAXMEM="1G"
fi

if [ -z  "$MC_MINMEM" ]; then
  MC_MINMEM=$MC_MAXMEM ;
fi

MC_JAVA_OPS="-Xmx$MC_MAXMEM -Xms$MC_MINMEM"   # java options for minecraft server

# Start the server, passing additional arguments if needed
rm -rf /input.con
touch /input.con
execCMD "tail -f /input.con | java $MC_JAVA_OPS -jar $MC_HOME/$MC_PROC nogui $*"