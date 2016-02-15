FROM alpine:3.3
ARG GIT_TOKEN

RUN apk add --update \
    py-pip \
&& rm -rf /var/cache/apk/*

COPY web_server /opt/web_server
ENTRYPOINT /usr/bin/python /opt/web_server/web_server.py
