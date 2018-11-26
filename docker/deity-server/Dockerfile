FROM falcon

# Copy to tmp location. after up the volume is mounted and we can copy to final destination
COPY ./server_default.json /usr/server_default.json

# use previous generated keys, so the host system wont think the ssh server changed on every rebuild
COPY ./sshServer/* /etc/ssh/
RUN chmod 600   /etc/ssh/*
 
WORKDIR /usr/src/my-app/server/

#CMD ["yarn","start"]
CMD ["wait-for-ok.sh","http://wordpress/wp-json/wp/v2/blog/info","15","yarn start"]
