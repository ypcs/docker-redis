FROM ypcs/debian:bookworm

ARG APT_PROXY

RUN /usr/lib/docker-helpers/apt-setup && \
    /usr/lib/docker-helpers/apt-upgrade && \
    apt-get --assume-yes install \
        gosu \
        redis-server && \
    /usr/lib/docker-helpers/apt-cleanup

COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /var/run/redis && \
    chown redis:redis /var/run/redis && \
    echo 'include /etc/redis/local.conf' >> /etc/redis/redis.conf && \
    sed -i "s/^daemonize /#daemonize /g" /etc/redis/redis.conf && \
    sed -i "s/^logfile /#logfile \/dev\/stdout/g" /etc/redis/redis.conf && \
    sed -i "s/^bind /#bind /g" /etc/redis/redis.conf


ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
USER redis
CMD ["redis-server", "/etc/redis/redis.conf"]

COPY local.conf /etc/redis/local.conf
