FROM alpine:3.3
ARG GIT_TOKEN

RUN apk add --update \
    gcc \
    python-dev \
    musl-dev \
    git \
    py-pip \
&& rm -rf /var/cache/apk/*

RUN mkdir -p /opt/worker

RUN git clone https://$GIT_TOKEN@github.com/seqvence/docker-bday-worker.git /opt/worker

RUN pip install --upgrade pip
RUN pip install -r /opt/worker/requirements.txt

