FROM java

ENV RUN_DECK_VERSION 2.7.1-1-GA

ENV RUN_DECK_CLI_VERSION 1.0.3
RUN wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck-${RUN_DECK_VERSION}.deb && dpkg -i rundeck-${RUN_DECK_VERSION}.deb && rm -f rundeck-${RUN_DECK_VERSION}.deb && wget https://github.com/rundeck/rundeck-cli/releases/download/v${RUN_DECK_CLI_VERSION}/rundeck-cli_${RUN_DECK_CLI_VERSION}-1_all.deb && dpkg -i rundeck-cli_${RUN_DECK_CLI_VERSION}-1_all.deb && rm -f rundeck-cli_${RUN_DECK_CLI_VERSION}-1_all.deb

ADD entrypoint.sh /entrypoint.sh

RUN sed -i s/grails.serverURL/#grails.serverURL/ /etc/rundeck/rundeck-config.properties

EXPOSE 4440

VOLUME /etc/rundeck
VOLUME /var/rundeck

CMD ["/bin/bash", "/entrypoint.sh"]
