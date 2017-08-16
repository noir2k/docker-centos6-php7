FROM centos:centos6.7
MAINTAINER BongKIM <bongkim@sdmalt.com>

# yum update
RUN yum clean all
RUN yum -y update

# yum default installed
RUN yum install -y yum-plugin-ovl
RUN yum -y install yum-utils epel-release wget git vim --nogpgcheck
RUN yum -y groupinstall "Development Tools"

# add repo(remi and webtatic)
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm

RUN yum repolist
RUN yum-config-manager --enable remi-php70

# install php 
RUN yum -y install php \
                php-common \
                php-mbstring \
                php-mcrypt \
                php-devel \
                php-xml \
                php-mysqlnd \
                php-pdo \
                php-opcache \
                php-bcmath --nogpgcheck

RUN yum -y install php-fpm --nogpgcheck

# install php optional
RUN yum -y install php-cli \
                php-gd \
                php-recode \
                php-tidy \
                php-pspell \
                php-pgsql \
                php-snmp \
                php-xmlrpc \
                php-process --nogpgcheck

RUN yum -y install php-pear  --nogpgcheck

# install php pecl
RUN yum -y install php-pecl-mysql \
                php-pecl-xdebug \
                php-pecl-zip \
                php-pecl-amqp \
                php-pecl-apcu \
                php-pecl-imagick \
                php-pecl-redis --nogpgcheck

# install php-memcached use remi repo
RUN yum -y --disablerepo=webtatic install php-pecl-memcached --nogpgcheck

# install composer
RUN cd tmp
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# service start httpd
RUN chkconfig httpd on

RUN usermod -u 1000 apache
#EXPOSE 80 443 8080 3306

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

