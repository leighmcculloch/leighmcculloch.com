FROM nginx
COPY source/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
