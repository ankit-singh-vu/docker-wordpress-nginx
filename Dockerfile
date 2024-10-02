# Base image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y nginx php-mysql curl wget unzip && \
    apt-get clean

# Add PHP repository and install PHP 8.2 with FPM and mysqli
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ondrej/php
RUN apt update
RUN apt install php8.2-fpm php8.2-mysqli -y


# Set up WordPress
WORKDIR /var/www/html
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Set up Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-available/wordpress
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

# Set up file permissions
RUN chown -R www-data:www-data /var/www/html

# Expose necessary ports
EXPOSE 80

# Start PHP-FPM and Nginx together
CMD service php8.2-fpm start && nginx -g 'daemon off;'
