FROM alpine:3.10

ENV WEB_ROOT /var/www
ENV USER_DIR /home/www-data

# create user www-data:www-data 1000:1000
RUN addgroup -g 1000 -S www-data \
    && adduser -u 1000 -h $USER_DIR -H -S -G www-data www-data \
    && mkdir $USER_DIR \
    && chown www-data:www-data $USER_DIR

# install
RUN apk update \
    && apk add --no-cache curl nginx php php-curl php-mbstring php-iconv php-openssl php-json php-phar php-ctype php-intl php-simplexml php-dom php-session php-fpm supervisor git openssh \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && chown -R www-data:www-data /var/lib/nginx \
    && chown -R www-data:www-data /var/tmp/nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php7/error.log

RUN rm -Rf /etc/nginx/sites-enabled \
    && rm -Rf /etc/nginx/conf.d/* \
    && rm -Rf $WEB_ROOT/*

COPY ./config/nginx /etc/nginx
COPY ./config/php7 /etc/php7
COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./www $WEB_ROOT
COPY ./bin /opt/
RUN chmod +x /opt/*

WORKDIR $WEB_ROOT

EXPOSE 8080

CMD ["/opt/entrypoint.sh"]

