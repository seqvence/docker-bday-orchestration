FROM alpine:3.3
ARG GIT_TOKEN

RUN apk add --update \
    git \
    py-pip \
    nginx \
    supervisor \
&& rm -rf /var/cache/apk/*

RUN mkdir -p /opt/webserver
RUN mkdir -p /etc/supervisor.d/

RUN git clone https://$GIT_TOKEN@github.com/seqvence/docker-bday-backend.git /opt/webserver

RUN pip install --upgrade pip
RUN pip install --upgrade gunicorn
RUN pip install -r /opt/webserver/requirements.txt

COPY gunicorn.conf /opt/
COPY nginx.conf /etc/nginx/
COPY gunicorn.ini /etc/supervisor.d/

RUN rm -f /etc/init.d/*


#ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf --nodaemon
