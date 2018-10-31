FROM wordpress:latest

RUN mkdir /root/.ssh/
RUN echo "StrictHostKeyChecking no " >> /root/.ssh/config
RUN apt-get update && apt-get install -q -y ssmtp mailutils git && rm -rf /var/lib/apt/lists/*
RUN echo "hostname=localhost.localdomain" >> /etc/ssmtp/ssmtp.conf
RUN echo "root=root@deity.io" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=deity_mailhog:1025" >> /etc/ssmtp/ssmtp.conf
RUN echo "sendmail_path=/usr/sbin/ssmtp -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini
RUN echo "localhost localhost.localdomain" >> /etc/hosts

RUN echo "# Log anything (except mail) of level info or higher." >> /etc/sysctl.d/00-alpine.conf 
RUN echo "# Don't log private authentication messages!" >> /etc/sysctl.d/00-alpine.conf 
RUN echo "*.info;mail.none;authpriv.none;cron.none                /var/log/messages" >> /etc/sysctl.d/00-alpine.conf 

RUN echo "# The authpriv file has restricted access." >> /etc/sysctl.d/00-alpine.conf 
RUN echo "authpriv.*                       var/log/secure" >> /etc/sysctl.d/00-alpine.conf 
COPY ./post-build.sh /usr/local/bin/post-build.sh
RUN chmod +x /usr/local/bin/post-build.sh 

WORKDIR /var
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html/
