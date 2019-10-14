#!/bin/sh

set -e

/usr/bin/supervisord -n -c /etc/supervisord.conf
