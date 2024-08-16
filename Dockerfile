FROM scratch AS rootfs

COPY ["./entrypoint.sh", "/usr/local/bin/"]



# Main image
FROM alpine:3.20

# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN set -eux \
    && apk --update --no-cache add libcap bash nfs-utils \
    && rm -rfv /etc/idmapd.conf /etc/exports \
    && mkdir -p /var/lib/nfs/rpc_pipefs \
    && mkdir -p /var/lib/nfs/v4recovery \
    && echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab \
    && echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

COPY --from=rootfs ["/", "/"]
LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 2049