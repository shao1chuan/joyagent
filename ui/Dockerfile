FROM registry.cn-hangzhou.aliyuncs.com/dockerhub_mirror/nginx
VOLUME /tmp
ENV LANG en_US.UTF-8

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create necessary directories
RUN mkdir -p /var/www && mkdir -p /var/www/html

# Copy dist files
ADD dist/ /var/www/html/

EXPOSE 3000