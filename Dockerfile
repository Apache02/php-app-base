FROM alpine:3.10

ENV WEB_ROOT /var/www

# create user www-data:www-data 1000:1000
RUN addgroup -g 1000 -S www-data && adduser -u 1000 -h /var/cache/nginx -H -S -G www-data www-data

# install
RUN apk update \
    && apk add --no-cache nginx php php-curl php-mbstring php-iconv php-openssl php-json php-phar php-ctype php-fpm supervisor git openssh \
    && cd /opt && wget -O - https://getcomposer.org/installer | php \
    && ln composer.phar /usr/bin/composer

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php7/error.log

RUN rm -Rf /etc/nginx/sites-enabled \
    && rm -Rf /etc/nginx/conf.d/* \
    && rm -Rf $WEB_ROOT/*

COPY ./config/nginx /etc/nginx
COPY ./config/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./www $WEB_ROOT
COPY ./bin /opt/
RUN chmod +x /opt/*

WORKDIR $WEB_ROOT

EXPOSE 80

CMD ["/opt/entrypoint.sh"]

