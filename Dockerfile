FROM ubuntu:bionic

## Install Base Packages
RUN apt-get update && apt-get -y install \
    apache2 \
    make \
    curl \
    git \
    gcc

## Install Perl
RUN apt-get update && apt-get -y install \
    libapache2-mod-perl2 \
    perl

RUN a2enmod perl

RUN a2enmod rewrite

RUN a2enmod cgid

EXPOSE 8080

RUN mkdir -p /var/www/html/site.com/httpdocs

RUN mkdir -p /var/www/site.com/logs/

RUN mkdir -p /var/www/site.com/cgi-bin

COPY lbsearch /var/www/site.com/cgi-bin/
COPY autocomplete /var/www/site.com/cgi-bin/

RUN chmod +x /var/www/site.com/cgi-bin/*

COPY ./site.conf /etc/apache2/sites-available/
RUN a2ensite site
RUN a2dissite 000-default.conf

CMD /usr/sbin/apache2ctl -D FOREGROUND
