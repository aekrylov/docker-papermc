## PaperMC server based on OpenJDK 8
[![](https://images.microbadger.com/badges/image/aekrylov/papermc.svg)](https://microbadger.com/images/aekrylov/papermc "Get your own image badge on microbadger.com")

This docker image builds and runs the Paper Minecraft server. 
It downloads a Paperclip JAR on startup for the version specified 
in the environment and saves it to the /minecraft folder

## Starting the container

To run the latest stable version of this docker image run

	docker run -d -p 25565:25565 -e EULA=true aekrylov/papermc

the parameter

	-e EULA=true

The is because Mojang now requires the end user to access their EULA, located at
https://account.mojang.com/documents/minecraft_eula, the be able to start the server.

the parameter

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

If you don't specify it will always compile the latest version but if you want a specific version you can specify it by adding

	-e MC_VER=<version>

For example, to build it with version 1.8 add

	-e MC_VER=1.8

to the docker run line.

## Memory settings

There are two environment variables to set maximum and initial memory for spigot.

### MC_MAXMEM

Sets the maximum memory to use <size>m for Mb or <size>g for Gb, if this parameter is not set 1 Gb is chosen, to set the maximum memory to 2 Gb

    -e MC_MAXMEM=2g

### MC_MINMEM

sets the initial memory reservation used, use <size>m for Mb or <size>g for Gb, if this parameter is not set, it is set to MC_MAXMEM, to set the initial size t0 512 Mb

    -e MC_MINMEM=512m

## Server logs

To get an output of the latest events from the server type

	docker logs papermc

more in the [Docker documentation](https://docs.docker.com/engine/reference/commandline/logs/)

## Sending commands to the server console

You don't need to have an interactive container to be able to send commands to the console. You can use the
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
(and the container). Docker commands are preferred.

## Having the minecraft files on the host machine

If you delete the container all your filer in minecraft will be gone. To save them where it's
easier to edit and do a backup of the files you can attach a directory from the host machine
(where you run the docker command) and attach it to the local file system in the container.
The syntax for it is

	-v /host/path/to/dir:/container/path/to/dir

To attach the minecraft directory in the container to directory /home/nimmis/mc-srv you add

	-v /home/nimmis/mc-srv:/minecraft

### problems with external mounted volumes

When a external volume is mounted the UID of the owner of the volume may not match the UID of the minecraft user (1000).
This can result in problems with write/read access to the files. 

To address this problem a check is done between UID of the owner of /minecraft and the UID of the user minecraft. 
If there is a mismatch the UID of the minecraft user is changed to match the UID of the directory.

If you don't want to do this and want to manually set the UID of the minecraft user there is a variable named 
`SPIGOT_UID` which defines the minecraft user UID, adding

	-e SPIGOT_UID=1132

sets the minecraft user UID to 1132.

## Issues

If you have any problems with or questions about this image, please contact us by submitting a ticket through a [GitHub issue](https://github.com/nimmis/docker-spigot/issues "GitHub issue")

1. Look to see if someone already filled the bug, if not add a new one.
2. Add a good title and description with the following information.
 - if possible an copy of the output from **cat /etc/BUILDS/*** from inside the container
 - any logs relevant for the problem
 - how the container was started (flags, environment variables, mounted volumes etc)
 - any other information that can be helpful

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

## Future features

- automatic backup
- plugins
- more....

