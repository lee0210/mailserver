FROM alpine:3.7

RUN apk update \
    && apk add --no-cache \
       runit \
       rsyslog \
       openssl \
       postfix \ 
       postfix-mysql \
       dovecot \
       dovecot-mysql \
    && rm -rf /var/cache/apk/*

EXPOSE 25 465 587 993 995

COPY bin /usr/local/bin
COPY etc /etc

ENTRYPOINT /usr/local/bin/entrypoint.sh
