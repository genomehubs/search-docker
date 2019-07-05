#!/bin/bash

if [ -s /conf/search.genomehubs.org.conf ]; then
  cp /conf/search.genomehubs.org.conf /etc/apache2/sites-available/
fi

/usr/sbin/apache2ctl -D FOREGROUND
