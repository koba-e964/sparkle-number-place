#!/bin/sh
CONFIG=/opt/lighttpd.conf


sed -ri "s/server.port = 80/server.port = "$PORT"/g" $CONFIG

lighttpd -D -f $CONFIG
