FROM alpine:3.3
ARG GIT_TOKEN

RUN apk add --update \
    git \
    py-pip \
&& rm -rf /var/cache/apk/*

RUN mkdir -p /opt/webserver

RUN git clone https://$GIT_TOKEN@github.com/seqvence/docker-bday-backend.git /opt/webserver

RUN pip install --upgrade pip
RUN pip install -r /opt/webserver/requirements.txt

