#Debian (jessie) 8.11
FROM scratch
LABEL maintainer='Frederico Martins <fredericosilva@softbox.com.br>'

ADD rootfs.tar.xz /

RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    vim \
    apache2 \
    curl \
    libaio1

RUN apt -y install lsb-release \
    apt-transport-https \ 
    ca-certificates \
    wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.3.list
RUN apt update && apt -y install php7.3 \
    libapache2-mod-php7.3

RUN apt -y install libapache2-mod-php7.3 \
    memcached \
    php7.3-memcached \
    php7.3-mysql \
    php7.3-dev \
    php-pear \
    php7.3-curl

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Enable Apache2 modules
RUN a2enmod rewrite

COPY virtual-host.conf /etc/apache2/sites-available/000-default.conf

# Apache listen on port 8081 configured on the docker-compose.yml 
RUN echo "Listen 8081" >> /etc/apache2/ports.conf

# Avoid Warning message AH00558 of the apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

CMD bash -c 'a2enmod rewrite && apache2 -DFOREGROUND'

EXPOSE 80
