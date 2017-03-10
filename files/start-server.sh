#!/bin/sh
# Ref: https://github.com/senyoltw/docker-difff/blob/master/Dockerfile
FILE=/usr/local/apache2/conf/httpd.conf
sed -ri "s/#LoadModule cgid_module/LoadModule cgid_module/g;" $FILE
sed -ri "s/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI/g;" $FILE
sed -ri "s/Listen 80/Listen "$PORT"/g;" $FILE
sed -ri "s/#AddHandler cgi-script .cgi/AddHandler cgi-script .rb .pl .cgi/g" $FILE

# start httpd
httpd-foreground
