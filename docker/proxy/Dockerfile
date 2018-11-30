FROM nginx:latest

RUN apt-get update \
  && apt-get install openssl \
  && mkdir -p /etc/nginx/ssl/falcon.develop \
  &&  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./deity.conf /etc/nginx/conf.d/deity.conf

COPY ./ssl/*  /etc/nginx/ssl/falcon.develop/

RUN chmod 600 /etc/nginx/ssl/falcon.develop/server.key
