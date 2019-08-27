#!/bin/bash

for f in /entrypoints/*.sh; do
  bash "$f" -H 
done

supervisord -c /etc/supervisor/conf.d/supervisord.conf