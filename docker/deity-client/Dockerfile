FROM falcon

COPY ./development.json /usr/client_development.json

# use previous generated keys, so the host system wont think the ssh server changed on every rebuild
COPY ./sshServer/* /etc/ssh/
RUN chmod 600   /etc/ssh/*

WORKDIR /usr/src/my-app/client/

CMD ["yarn","start"]


