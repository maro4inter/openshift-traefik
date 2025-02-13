FROM alpine:3.10
RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='armv6' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
	wget --quiet -O /tmp/traefik.tar.gz "https://github.com/containous/traefik/releases/download/v2.0.6/traefik_v2.0.6_linux_$arch.tar.gz"; \
	tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik; \
	rm -f /tmp/traefik.tar.gz; \
	chmod +x /usr/local/bin/traefik

COPY entrypoint.sh /entrypoint.sh

RUN set -ex; \
	chmod +x /entrypoint.sh ; \
	chown 1001:1001 entrypoint.sh

EXPOSE 8080 8443 8081

USER 1001

ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]
#CMD ["traefik","--configfile /etc/traefik/traefik.toml"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" \
	org.opencontainers.image.url="https://traefik.io" \
	org.opencontainers.image.title="Traefik" \
	org.opencontainers.image.description="A modern reverse-proxy" \
	org.opencontainers.image.version="v1.7.19" \
	org.opencontainers.image.documentation="https://docs.traefik.io"
