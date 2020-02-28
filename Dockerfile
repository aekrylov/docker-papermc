FROM openjdk:8-jdk

MAINTAINER nimmis <kjell.havneskold@gmail.com>

# MC_HOME         default directory for SPIGOT-server
# MC_VER          default minecraft version to compile
ENV MC_HOME=/minecraft \
    MC_VER=latest

# Make special user for minecraft to run in
RUN /usr/sbin/useradd -s /bin/bash -d /minecraft -m minecraft

# Install required packages
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean all

# add extra files needed
COPY rootfs /

# expose minecraft port
EXPOSE 25565

USER minecraft
WORKDIR /minecraft

ENTRYPOINT ["/bin/bash", "/start.sh"]