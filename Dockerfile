FROM alpine:latest
MAINTAINER Eugene Savchenko


ENV SSH_SERVER_KEYS /etc/ssh/host_keys/


RUN apk -U --no-cache add bash openssh sudo && \
    mkdir -p ${SSH_SERVER_KEYS} && \
    rm -rf /var/cache/apk/* /tmp/*


COPY rootfs /


RUN chmod a+x /usr/local/bin/entrypoint.sh


VOLUME ["${SSH_SERVER_KEYS}"]


ENTRYPOINT ["entrypoint.sh"]
