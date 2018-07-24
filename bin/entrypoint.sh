#!/bin/sh

echo connect = host=db dbname=mail user=root password=$(cat /run/secrets/mysql_password) >> /etc/dovecot/dovecot-sql.conf.ext
echo password = $(cat /run/secrets/mysql_password) >> /etc/postfix/mysql_alias_maps
echo password = $(cat /run/secrets/mysql_password) >> /etc/postfix/mysql_mailbox_maps
echo mydomain = $(cat /run/secrets/mydomain) >> /etc/postfix/main.cf

postmap /run/secrets/sasl_passwd

adduser -u 2000 mailuser
addgroup -g 5000 mailgroup
addgroup mailuser mailgroup
chown -R mailuser:mailgroup /var/mail

exec runsvdir -P /etc/service
