## PaperMC server based on OpenJDK 8
[![](https://images.microbadger.com/badges/image/aekrylov/papermc.svg)](https://microbadger.com/images/aekrylov/papermc "Get your own image badge on microbadger.com")

This docker image builds and runs the [PaperMC](https://papermc.io/) Minecraft server. 
It downloads a Paperclip JAR on startup for the version specified 
in the environment and saves it to the /minecraft folder.

The image is based on [nimmis/docker-spigot](https://github.com/nimmis/docker-spigot), but was heavily refactored

## How to use

1. Prepare a `minecraft` folder that the server will store the data in. This is not required, 
    but I highly recommend storing world data outside containers.

    If you're migrating from Spigot/non-docker Paper then simply make sure you dont have any `server-*.jar` files inside it

2. [Recommended] Create a minecraft user on the host system and make it owner of the `minecraft` folder. 
    This way the server will be run from a non-root user

3. Run the server:
    ```shell script
    docker run -d -p 25565:25565 -e EULA=true -e MC_VER=<Minecraft version> --name papermc aekrylov/papermc
    ```
   You may specify any Minecraft version PaperMC has been built against (check a list [here](https://papermc.io/legacy)). 
   Note that `-e EULA=true` indicates you agree with [Mojang EULA](https://account.mojang.com/documents/minecraft_eula), which is required to run the server.

## Configuring the server

You can change config files the standard way. See [the docs](https://paper.readthedocs.io/en/latest/server/configuration.html)
for a list op PaperMC configuration options. Arguments may be passed with docker run command. Also some predefied
variables are available.

### Memory settings

You can customize memory allocation setting by passing environment variables to the container. Example:

    docker run <..> -e MC_MAXMEM=2g -e MC_MINMEM=1g

Available variables:
* `MC_MAXMEM` sets `-Xmx` (max amount of RAM Java can use). use `m` for megabytes, `g` for gigabytes. Default is `1g`
* `MC_MINMEM` sets `-Xms`, i.e. how much memory will be allocated right away. The default is equal to `MC_MAXMEM`

### Additional JVM options

You can pass additional JVM options using `JAVA_OPTS` env variable. Memory settings are prepended to it on startup

## Server logs

To get an output of the latest events from the server type

	docker logs papermc

more in the [Docker documentation](https://docs.docker.com/engine/reference/commandline/logs/)

## Sending commands to the server console

Sending commands by attaching to the container is not available. Run `mc_send` command with `docker exec`. For example

	docker exec papermc mc_send op username

The output will look like this

    > op username
    === Last lines of output (Ctrl-C to close): ===
    [18:42:40 INFO]: View Distance: 10
    [18:42:40 INFO]: Arrow Despawn Rate: 1200
    [18:42:40 INFO]: Zombie Aggressive Towards Villager: true
    [18:42:40 INFO]: Nerfing mobs spawned from spawners: false
    [18:42:40 INFO]: Preparing start region for level minecraft:overworld (Seed: -1030601061642205236)
    [18:42:40 INFO]: Preparing start region for level minecraft:the_nether (Seed: -1030601061642205236)
    [18:42:40 INFO]: Preparing start region for level minecraft:the_end (Seed: -1030601061642205236)
    [18:42:40 INFO]: Time elapsed: 92 ms
    [18:42:40 INFO]: Done (14.371s)! For help, type "help"
    [18:42:40 INFO]: Timings Reset
    [18:46:19 INFO]: Made username a server operator

It will continue to output everything from the console until you press CTRL-C

### /restart caveat

Due to the nature of Docker, the server can't restart by itself, so `/restart` command will simply stop the server 
(and the container). Using Docker commands (`docker stop` / `docker start`) is preferred. `docker stop` stops the server gracefully.

## Mounted volume caveats

When a external volume is mounted the UID of the owner of the volume may not match the UID of the minecraft user (1000).
This can result in problems with write/read access to the files. 

To address this problem a check is done between UID of the owner of /minecraft and the UID of the user minecraft. 
If there is a mismatch the UID of the minecraft user is changed to match the UID of the directory.

If you don't want to do this and want to manually set the UID of the minecraft user there is a variable named 
`MC_UID` which defines the minecraft user UID, adding

	-e MC_UID=1132

sets the minecraft user UID to 1132.

## Issues

If you have any problems with or questions about this image, please submit a ticket through a [GitHub issue](https://github.com/aekrylov/docker-papermc/issues)
