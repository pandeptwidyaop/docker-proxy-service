FROM alpine

RUN apk add --update openssh-client && rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]