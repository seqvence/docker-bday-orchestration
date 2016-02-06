FROM ubuntu:14.04
ARG GIT_TOKEN

RUN apt-get update && apt-get install -y \
    git \
    python-pip \
    build-essential \
    python-dev \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/webserver
RUN git clone https://$GIT_TOKEN@github.com/seqvence/docker-bday-backend.git /opt/webserver
RUN pip install -r /opt/webserver/requirements.txt
RUN apt-get remove -y \
    git \
    python-pip \
    build-essential \
    python-dev

