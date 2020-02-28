FROM nimmis/java:openjdk-8-jdk

MAINTAINER nimmis <kjell.havneskold@gmail.com>

# MC_HOME         default directory for SPIGOT-server
# MC_VER          default minecraft version to compile
# MC_AUTORESTART  set to yes to restart if minecraft stop command is executed
ENV MC_HOME=/minecraft \
    MC_VER=latest \
    MC_AUTORESTART=yes

# add extra files needed
COPY rootfs /

RUN apt-get update && \

    # upgrade OS
    apt-get -y dist-upgrade && \

    # Make info file about this build
    printf "Build of nimmis/spigot:latest, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /etc/BUILDS/spigot && \

    # install application
    apt-get install -y wget git && \

    # Make special user for minecraft to run in
    /usr/sbin/useradd -s /bin/bash -d /minecraft -m minecraft && \

    # remove apt cache from image
    apt-get clean all


# expose minecraft port
EXPOSE 25565


