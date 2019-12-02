FROM alpine:3.10
RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='arm' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
	wget --quiet -O /usr/local/bin/traefik "https://github.com/containous/traefik/releases/download/v1.7.19/traefik_linux-$arch"; \
	chmod +x /usr/local/bin/traefik
COPY entrypoint.sh /
RUN set -ex; \
	chmod +x /entrypoint.sh ; \
	chown 1001:1001 entrypoint.sh
	
USER 1001
EXPOSE 8080 8081 8443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik","--defaultentrypoints=http,https","--entryPoints='Name:http Address::8080'","--entryPoints='Name:https Address::8443 TLS'","--entrypoints.web.address=:8081"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" \
	org.opencontainers.image.url="https://traefik.io" \
	org.opencontainers.image.title="Traefik" \
	org.opencontainers.image.description="A modern reverse-proxy" \
	org.opencontainers.image.version="v1.7.19" \
	org.opencontainers.image.documentation="https://docs.traefik.io"
