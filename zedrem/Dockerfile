FROM ubuntu
MAINTAINER Emmanuel Frecon <efrecon@gmail.com>

RUN apt-get update -y && \
    apt-get install -y wget && \
    wget -qO /bin/zedrem "http://get.zedapp.org/zedrem-Linux-x86_64" && \
    chmod a+x /bin/zedrem

EXPOSE 7337

ENTRYPOINT [ "/bin/zedrem" ]
CMD [ "--server"]