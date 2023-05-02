FROM php:8.2.5-fpm

WORKDIR /opt/project

# OS updates
RUN apt update && apt dist-upgrade -y

# Software requirements
RUN apt install -y --no-install-recommends git htop nginx procps unzip wget

# Composer binary
RUN cd /tmp && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    composer --version

# Symfony binary
RUN apt install -y --no-install-recommends wget && \
    cd /tmp && \
    wget https://get.symfony.com/cli/installer && \
    bash installer && \
    rm installer && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# PHP Extensions
RUN apt install -y --no-install-recommends libicu-dev && docker-php-ext-install intl

# S6 Overlay
ARG S6_OVERLAY_VERSION=3.1.4.1
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Launch S6 Overlay supervisor
ENTRYPOINT ["/init"]
