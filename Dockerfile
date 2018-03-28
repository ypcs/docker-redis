FROM ypcs/debian:stretch

RUN \
    /usr/local/sbin/docker-upgrade && \
    apt-get --assume-yes install \
        redis-server && \
    /usr/local/sbin/docker-cleanup

COPY entrypoint.sh /entrypoint.sh

RUN \
    mkdir -p /var/run/redis && \
    chown redis:redis /var/run/redis && \
    sed -i "s/^daemonize yes/daemonize no/g" /etc/redis/redis.conf && \
    sed -i "s/^logfile .*/logfile \/dev\/stdout/g" /etc/redis/redis.conf

ENTRYPOINT ["/entrypoint.sh"]

RUN echo "Source: https://github.com/ypcs/docker-redis\nBuild date: $(date --iso-8601=ns)" >/README
USER redis
CMD ["redis-server", "/etc/redis/redis.conf"]
