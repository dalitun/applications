FROM mongo

ENV POD_NAMESPACE default
ENV POD_NAME mongo
ENV NODE_COUNT 3

RUN echo "deb http://http.debian.net/debian wheezy-backports main"> /etc/apt/sources.list.d/jq.list
RUN apt-get update && apt-get install -y curl jq
COPY rs-config.sh /rs-config.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /rs-config.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"] 
CMD ["--replSet","rs0"]





                                   
                                   