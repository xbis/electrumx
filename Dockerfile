FROM python:3.6-alpine3.6

COPY ./bin /usr/local/bin
COPY ./ electrumx/

RUN chmod a+x /usr/local/bin/* && \
    apk add --no-cache build-base openssl && \
    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing leveldb-dev && \
    pip3 install aiohttp pylru plyvel && \
    cd electrumx && \
    python3 setup.py install && \
    apk del build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV DB_DIRECTORY /data
ENV PEER_DISCOVERY=
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
WORKDIR /data

EXPOSE 19200
EXPOSE 19201
EXPOSE 19202

CMD ["init"]
