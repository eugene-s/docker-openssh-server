FROM alpine:latest
MAINTAINER Eugene Savchenko

ENV SSH_SERVER_KEYS /etc/ssh/host_keys/

COPY /rootfs /

RUN apk update && \
    apk add bash openssh sudo && \
    mkdir -p ${SSH_SERVER_KEYS} && \
    echo -e "HostKey ${SSH_SERVER_KEYS}ssh_host_rsa_key" >> /etc/ssh/sshd_config && \
    echo -e "HostKey ${SSH_SERVER_KEYS}ssh_host_dsa_key" >> /etc/ssh/sshd_config && \
    echo -e "HostKey ${SSH_SERVER_KEYS}ssh_host_ecdsa_key" >> /etc/ssh/sshd_config && \
    echo -e "HostKey ${SSH_SERVER_KEYS}ssh_host_ed25519_key" >> /etc/ssh/sshd_config && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin\ yes/" /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd && \
    mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh && \
    chmod a+x /usr/local/bin/* && \
    rm -rf /var/cache/apk/* /tmp/*

VOLUME ["${SSH_SERVER_KEYS}"]

EXPOSE 22

ENTRYPOINT ["entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]
