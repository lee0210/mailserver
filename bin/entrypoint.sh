#!/bin/sh

postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd.db

adduser -u 2000 mailuser
addgroup -g 5000 mailgroup
addgroup mailuser mailgroup
chown -R mailuser:mailgroup /var/mail

echo connect = host=db dbname=mail user=root password=$(cat /run/secrets/mysql_password) >> /etc/dovecot/dovecot-sql.conf.ext
echo ssl_cert = \</etc/certs/$(cat /run/secrets/ca_name) >> /etc/dovecot/conf.d/10-ssl.conf
echo ssl_key = \</etc/certs/$(cat /run/secrets/ca_name) >> /etc/dovecot/conf.d/10-ssl.conf

echo password = $(cat /run/secrets/mysql_password) >> /etc/postfix/mysql_alias_maps
echo password = $(cat /run/secrets/mysql_password) >> /etc/postfix/mysql_mailbox_maps
echo smtpd_tls_cert_file = /etc/certs/$(cat /run/secrets/ca_name) >> /etc/postfix/main.cf
echo smtpd_tls_key_file = /etc/certs/$(cat /run/secrets/ca_name) >> /etc/postfix/main.cf
echo smtp_tls_CAfile = /etc/ssl/certs/$(cat /run/secrets/ca_name) >> /etc/postfix/main.cf

exec runsvdir -P /etc/service
