FROM alpine:3.5


ENV VERSION=2.7.1


RUN     apk add --update openjdk8-jre bash curl wget jq && \
        mkdir -p /rundeck/ && \
        wget -O /rundeck/rundeck-launcher.jar \
            http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-${VERSION}.jar && \
        rm -Rf /var/cache/apk/*



COPY ./entrypoint.sh /entrypoint.sh
COPY ./rundeck-config.properties /rundeck/server/config/rundeck-custom.properties

ENV RD_BASE=/rundeck \
    RD_WEB_CONTEXT=/ \
    RD_URL=http://localhost:4440 \
    RD_USER=admin \
    RD_PASSWORD=admin\
    MYSQL_USER=rd \
    MYSQL_PASSWORD=rd \
    MYSQL_DATABASE=rundeck \
    MYSQL_HOST=mysql \
    MYSQL_PORT=3306

EXPOSE 4440

VOLUME  [ "/rundeck/var/", "/rundeck/projects" ]

CMD ["/bin/bash", "/entrypoint.sh"]
