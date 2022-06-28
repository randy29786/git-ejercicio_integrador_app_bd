FROM nginx:alpine

COPY ./bienvenido.conf /etc/nginx/conf.d
COPY ./index-bienvenido.html /usr/share/nginx/html

RUN rm -f /etc/nginx/conf.d/default.conf


