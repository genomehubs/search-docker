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

RUN a2enmod cgi

RUN a2enmod alias

RUN a2enmod proxy

EXPOSE 8080

RUN mkdir -p /var/www/search.genomehubs.org/httpdocs

RUN mkdir -p /var/www/search.genomehubs.org/logs/

RUN mkdir -p /var/www/search.genomehubs.org/cgi-bin

RUN apt update && apt -y install cpanminus

RUN cpanm CGI::Safe DBI JSON

RUN cpanm List::Util@1.33

RUN apt-get -y install libdbd-mysql-perl

COPY lbsearch /var/www/search.genomehubs.org/cgi-bin/

COPY autocomplete /var/www/search.genomehubs.org/cgi-bin/

RUN chmod +x /var/www/search.genomehubs.org/cgi-bin/*

COPY ./search.genomehubs.org.conf /etc/apache2/sites-available/

RUN a2enmod headers

RUN a2dissite 000-default

RUN a2dissite default-ssl

RUN a2ensite search.genomehubs.org

COPY startup.sh /

RUN useradd searchuser

RUN sed -i 's/80/8000/' /etc/apache2/ports.conf

RUN chown -R searchuser: /var/www/search.genomehubs.org

RUN chown -R searchuser: /var/run/apache2

RUN chown -R searchuser: /var/log/apache2

RUN chown -R searchuser: /var/lock/apache2

RUN chown -R searchuser: /etc/apache2/sites-available

RUN usermod -a -G www-data searchuser

USER searchuser

CMD /startup.sh
