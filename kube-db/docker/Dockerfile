FROM mongo

ENV POD_NAMESPACE default
ENV POD_NAME mongo
ENV NODE_COUNT 3

RUN echo "deb http://http.debian.net/debian wheezy-backports main"> /etc/apt/sources.list.d/jq.list
RUN apt-get update && apt-get install -y curl jq
COPY rs-config.sh /rs-config.sh
RUN chmod +x /rs-config.sh





                                   
                                   