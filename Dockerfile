FROM debian:bullseye-slim

MAINTAINER Paulo Murer

RUN apt-get update

RUN apt-get install -y sudo wget curl vim
RUN apt-get install -y xvfb
RUN apt-get install -y openbox tint2
RUN apt-get install -y x11vnc
RUN apt-get install -y firefox
RUN apt-get install -y xterm
RUN apt-get install -y lxterminal
RUN apt-get install -y gmrun
RUN apt-get install -y pcmanfm

ARG PARAM_UID=8900
ARG PARAM_GID=8900

RUN groupadd -g "${PARAM_GID}" "vncuser" || true
RUN adduser --disabled-password --uid "${PARAM_UID}" --gid "${PARAM_GID}" --gecos "vncuser" "vncuser"
RUN groupadd -r supersudo
RUN echo "%supersudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/supersudo
RUN usermod -a -G supersudo "vncuser"

ADD config /opt/config

RUN chmod +x /opt/config/docker-entrypoint.sh /opt/config/openbox/autostart

RUN rm -rf /etc/xdg/openbox && \
    cp -R /opt/config/openbox /etc/xdg/openbox && \
    (rm -rf /etc/xdg/tint2 || true) && \
    cp -R /opt/config/tint2 /etc/xdg/tint2

USER $USER
ENV HOME /home/$USER
ENV USER $USER
WORKDIR /home/$USER

ENV DISPLAY :99
EXPOSE 5800

CMD "/opt/config/docker-entrypoint.sh"
