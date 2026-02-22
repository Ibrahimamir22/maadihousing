FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf && apk add --no-cache openssl

COPY nginx.conf /etc/nginx/conf.d/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/docker-entrypoint.sh"]

