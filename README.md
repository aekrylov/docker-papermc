## PaperMC server based on OpenJDK 8
[![](https://images.microbadger.com/badges/image/aekrylov/papermc.svg)](https://microbadger.com/images/aekrylov/papermc "Get your own image badge on microbadger.com")

This docker image builds and runs the Paper Minecraft server. 
It downloads a Paperclip JAR on startup for the version specified 
in the environment and saves it to the /minecraft folder.

The image is based on [nimmis/docker-spigot](https://github.com/nimmis/docker-spigot), but was heavily refactored

## How to use

To run the latest stable version of this image run

	docker run -d -p 25565:25565 -e EULA=true aekrylov/papermc

Note that

	-e EULA=true

indicates you agree with [Mojang EULA](https://account.mojang.com/documents/minecraft_eula), which is required to run the server.

The parameter

	-p 25565:25565

tell on witch external port the internal 25565 should be connected, in this case the same, if
you only type -p 25565 it will connect to a random port on the machine

## Giving the container a name

To make it easier to handle you container you can give it a name instead of the long
number thats normally give to it, add a

	--name papermc

to the run command to give it the name minecraft, then you can start it easier with

	docker start papermc
	docker stop papermc

## Selecting Minecraft version

By default the image will download the latest available version of PaperMC. To use the server for a specific 
Minecraft version, add an env parameter to the `docker run` line

	-e MC_VER=<version>

For example, to build it with version 1.8 add

	-e MC_VER=1.8

## Memory settings

There are two environment variables to set maximum and initial memory for spigot.

### MC_MAXMEM

Sets the maximum memory to use <size>m for Mb or <size>g for Gb, if this parameter is not set 1 Gb is chosen, to set the maximum memory to 2 Gb

    -e MC_MAXMEM=2g

### MC_MINMEM

Sets the initial memory reservation used, use <size>m for Mb or <size>g for Gb, if this parameter is not set, it is set to MC_MAXMEM, to set the initial size t0 512 Mb

    -e MC_MINMEM=512m

## Server logs

To get an output of the latest events from the server type

	docker logs papermc

more in the [Docker documentation](https://docs.docker.com/engine/reference/commandline/logs/)

## Sending commands to the server console

You don't need to have an interactive container to be able to send commands to the console. You can use
`mc_send` executable available in the running container, using `docker exec`. For example

	docker exec papermc mc_send "time set day"

If this was the first command issued after a start the output should look like

	[13:02:15 INFO]: Zombie Aggressive Towards Villager: true
	[13:02:15 INFO]: Experience Merge Radius: 3.0
	[13:02:15 INFO]: Preparing start region for level 0 (Seed: 506255305130990210)
	[13:02:16 INFO]: Preparing spawn area: 22%
	[13:02:17 INFO]: Preparing spawn area: 99%
	[13:02:17 INFO]: Preparing start region for level 1 (Seed: 506255305130990210)
	[13:02:18 INFO]: Preparing spawn area: 95%
	[13:02:18 INFO]: Preparing start region for level 2 (Seed: 506255305130990210)
	[13:02:18 INFO]: Server permissions file permissions.yml is empty, ignoring it
	[13:02:18 INFO]: Done (3.650s)! For help, type "help" or "?"
	[13:12:35 INFO]: Set the time to 1000

It will continue to output everything from the console until you press CTRL-C

### /restart

Due to the nature of Docker, the server can't restart by itself, so /restart command will simply stop the server 
(and the container). Using Docker commands (`docker stop` / `docker start`) is preferred.

## Having the minecraft files on the host machine

If you delete the container all your filer in minecraft will be gone. To save them where it's
easier to edit and do a backup of the files you can attach a directory from the host machine
(where you run the docker command) and attach it to the local file system in the container.
The syntax for it is

	-v /host/path/to/dir:/container/path/to/dir

To attach the minecraft directory in the container to directory /home/nimmis/mc-srv you add

	-v /home/nimmis/mc-srv:/minecraft

### Mounted volume caveats

When a external volume is mounted the UID of the owner of the volume may not match the UID of the minecraft user (1000).
This can result in problems with write/read access to the files. 

To address this problem a check is done between UID of the owner of /minecraft and the UID of the user minecraft. 
If there is a mismatch the UID of the minecraft user is changed to match the UID of the directory.

If you don't want to do this and want to manually set the UID of the minecraft user there is a variable named 
`MC_UID` which defines the minecraft user UID, adding

	-e MC_UID=1132

sets the minecraft user UID to 1132.

## Issues

If you have any problems with or questions about this image, please submit a ticket through a [GitHub issue](https://github.com/aekrylov/docker-papermc/issues "GitHub issue")
