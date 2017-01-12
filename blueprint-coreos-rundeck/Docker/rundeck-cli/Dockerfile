FROM alpine:3.5

ENV VERSION=1.0.3

RUN     apk add --update openjdk8-jre bash curl openssh ca-certificates wget && \
        update-ca-certificates && \
        wget https://github.com/rundeck/rundeck-cli/releases/download/v${VERSION}/rd-${VERSION}.zip && \
        unzip rd-${VERSION}.zip && rm -rf rd-${VERSION}.zip && mv rd-${VERSION} rd &&\
        rm -Rf /var/cache/apk/*



COPY ./entrypoint.sh /entrypoint.sh
COPY ./snapshot.xml /snapshot.xml

ENV  RD_URL=http://localhost:4440 \
     RD_HOST=localhost \
     RD_USER=admin \
     RD_PASSWORD=admin



CMD ["/bin/bash", "/entrypoint.sh"]
