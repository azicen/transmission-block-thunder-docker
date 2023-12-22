FROM bitnami/git:2.43.0 AS git-image

WORKDIR /app
RUN git clone https://github.com/ronggang/transmission-web-control.git


FROM curlimages/curl:8.5.0 AS curl-image

WORKDIR /app
RUN curl https://blog.zscself.com/posts/66b00f02/transmission-common_3.00-1_all.deb -o transmission-common.deb
RUN curl https://blog.zscself.com/posts/66b00f02/transmission-cli_3.00-1_amd64.deb -o transmission-cli.deb
RUN curl https://blog.zscself.com/posts/66b00f02/transmission-daemon_3.00-1_amd64.deb -o transmission-daemon.deb


FROM debian:11

COPY --from=git-image /app/transmission-web-control/src /app/transmission-web-control/src
COPY --from=git-image /app/transmission-web-control/LICENSE /app/transmission-web-control/LICENSE
COPY --from=curl-image /app /app/deb

RUN apt update && apt upgrade -y --no-install-recommends
RUN apt install -y --no-install-recommends libcurl4 libevent-2.1-7 libminiupnpc17 libnatpmp1

WORKDIR /app/deb
RUN dpkg -i transmission-common.deb
RUN dpkg -i transmission-cli.deb
RUN dpkg -i transmission-daemon.deb
RUN rm -rf /app/deb

RUN apt autoremove -y && apt autoclean -y && apt clean

COPY settings.json /app/config/settings.json

WORKDIR /downloads

ENV TRANSMISSION_HOME=/app/config
ENV TRANSMISSION_WEB_HOME=/app/transmission-web-control/src

EXPOSE 9091 51413/tcp 51413/udp

ENTRYPOINT ["/usr/bin/transmission-daemon", "-f"]
