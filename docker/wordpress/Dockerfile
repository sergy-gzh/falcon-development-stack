FROM wordpress:latest
COPY ./post-build.sh /usr/local/bin/post-build.sh

RUN mkdir /root/.ssh/ \
&& echo "StrictHostKeyChecking no " >> /root/.ssh/config \
&& apt-get update && apt-get install -q -y ssmtp mailutils git && rm -rf /var/lib/apt/lists/* \
&& echo "hostname=localhost.localdomain" >> /etc/ssmtp/ssmtp.conf \
&& echo "root=root@deity.io" >> /etc/ssmtp/ssmtp.conf \
&& echo "mailhub=deity_mailhog:1025" >> /etc/ssmtp/ssmtp.conf \
&& echo "sendmail_path=/usr/sbin/ssmtp -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini \
&& echo "localhost localhost.localdomain" >> /etc/hosts \
&& echo "# Log anything (except mail) of level info or higher." >> /etc/sysctl.d/00-alpine.conf  \
&& echo "# Don't log private authentication messages!" >> /etc/sysctl.d/00-alpine.conf \ 
&& echo "*.info;mail.none;authpriv.none;cron.none                /var/log/messages" >> /etc/sysctl.d/00-alpine.conf  \
&& echo "# The authpriv file has restricted access." >> /etc/sysctl.d/00-alpine.conf \ 
&& echo "authpriv.*                       var/log/secure" >> /etc/sysctl.d/00-alpine.conf \ 
&&  chmod +x /usr/local/bin/post-build.sh 

WORKDIR /var
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&&  chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html/
