#!/bin/sh

postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd.db

adduser -u 2000 mailuser
addgroup -g 5000 mailgroup
addgroup mailuser mailgroup
chown -R mailuser:mailgroup /var/mail

echo connect = host=db dbname=mail user=root password=$(cat /run/secrets/mysql_password) >> /etc/dovecot/dovecot-sql.conf.ext

echo password = $(cat /run/secrets/mysql_password) >> /etc/postfix/mysql_alias_maps
echo password = $(cat /run/secrets/mysql_password) >> /etc/postfix/mysql_mailbox_maps


exec runsvdir -P /etc/service
