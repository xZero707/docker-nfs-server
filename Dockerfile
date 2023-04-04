ARG BUILD_FROM=alpine:3.15

FROM $BUILD_FROM

# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN set -eux \
    && apk --update --no-cache add bash nfs-utils \
    && rm -v /etc/idmapd.conf /etc/exports \
    && mkdir -p /var/lib/nfs/rpc_pipefs \
    && mkdir -p /var/lib/nfs/v4recovery \
    && echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab \
    && echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

EXPOSE 2049

# setup entrypoint
COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>"
