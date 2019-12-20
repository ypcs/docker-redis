FROM ypcs/debian:buster

RUN /usr/lib/docker-helpers/apt-setup && \
    /usr/lib/docker-helpers/apt-upgrade && \
    apt-get --assume-yes install \
        gosu \
        redis-server && \
    /usr/lib/docker-helpers/apt-cleanup

COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /var/run/redis && \
    chown redis:redis /var/run/redis && \
    sed -i "s/^daemonize yes/daemonize no/g" /etc/redis/redis.conf && \
    sed -i "s/^logfile .*/logfile \/dev\/stdout/g" /etc/redis/redis.conf && \
    sed -i "s/^bind .*/bind 0.0.0.0/g" /etc/redis/redis.conf

ENTRYPOINT ["/entrypoint.sh"]

USER redis
CMD ["redis-server", "/etc/redis/redis.conf"]
