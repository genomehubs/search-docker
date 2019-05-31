#!/bin/bash

if [ -s /conf/search.genomehubs.org.conf ]; then
  cp /conf/search.genomehubs.org.conf /etc/apache2/sites-available/
  a2enmod proxy
fi

a2ensite search.genomehubs.org

/usr/sbin/apache2ctl -D FOREGROUND
