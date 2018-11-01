FROM node:carbon-alpine
RUN apk update && apk upgrade && apk add --no-cache git openssh openssh-server yarn curl ssmtp;

# Copy to tmp location. after up the volume is mounted and we can copy to final destination
COPY ./server_default.json /usr/server_default.json

# Copy helper scripts
COPY ./wait-for-ok.sh /usr/local/bin/wait-for-ok.sh
RUN chmod +x /usr/local/bin/wait-for-ok.sh



# Setup the connection to the mailhog server
RUN echo "hostname=localhost.localdomain" >> /etc/ssmtp/ssmtp.conf
RUN echo "root=root@deity.io" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=deity_mailhog:1025" >> /etc/ssmtp/ssmtp.conf
RUN echo "localhost localhost.localdomain" >> /etc/hosts




# Setup ssh server for remote debugging
RUN echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

#use previous generated keys, so the host system wont think the ssh server changed on every rebuild
COPY ./sshServer/* /etc/ssh/
RUN chmod 600   /etc/ssh/*


RUN adduser -D  nodedebug
# Ok this is the HACK. if i make a user without password it doesn't work.
# but after deleteing the password that was never created. it does work
RUN passwd -d nodedebug

RUN mkdir /home/nodedebug/.ssh/
COPY ./nodedebug/id_rsa_nodedebug.pub /home/nodedebug/.ssh/authorized_keys
#RUN cat /home/nodedebug/id_rsa.pub >> /home/nodedebug/.ssh/authorized_keys
RUN chmod 600 -R  /home/nodedebug/.ssh/
RUN chmod 700 /home/nodedebug/.ssh
RUN chown -R nodedebug:nodedebug /home/nodedebug/.ssh

EXPOSE 22
#try not to start 
# RUN chmod -x /etc/init.d/sshd
# CMD ["/usr/sbin/sshd","-D"]
# End of SSHServer config 



WORKDIR /usr/src
