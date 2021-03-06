FROM openjdk:8-jre-slim

MAINTAINER aekrylov <github@aekrylov.me>

# MC_HOME         default directory for Minecraft data
ENV MC_HOME=/minecraft

# Make special user for minecraft to run in
RUN /usr/sbin/useradd -s /bin/bash -d /minecraft -m minecraft

# Install required packages
RUN apt-get update && \
    apt-get install -qy wget && \
    apt-get clean all

# add extra files needed
COPY rootfs /
RUN chmod +x /usr/local/bin/mc_send
RUN chmod +x /start.sh

# expose minecraft port
EXPOSE 25565

WORKDIR /minecraft

ENTRYPOINT ["/start.sh"]