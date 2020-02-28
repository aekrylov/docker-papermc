#!/bin/bash
#
# accept eula if set
#
# (c) 2016 nimmis <kjell.havneskold@gmail.com>


if [ ! -f $MC_HOME/eula.txt  ] ; then
     execCMD "echo '#EULA file created by minecraft script\neula=false' > $MC_HOME/eula.txt"
fi

if [ ! -z $EULA ] ; then
  echo "eula=$EULA" > $MC_HOME/eula.txt
  chown minecraft $MC_HOME/eula.txt
fi

grep eula $MC_DIR/eula.txt |  grep -q 'true' || echo "EULA not accepted! run with EULA=1 in env to accept" >&2 && exit 1
