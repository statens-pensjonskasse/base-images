ARG BUILDKIT_IMAGE_TAG="master"
FROM cr.spk.no/docker-hub/moby/buildkit:${BUILDKIT_IMAGE_TAG}-rootless

USER root

# Henter gjeldende rotsertifikat fra yum-server
ADD --chmod=644 https://yum.spk.no/pub/pki/spk-root-ca-current.pem /usr/local/share/ca-certificates/
# Henter gammelt rotsertifikat hvis vi er i en overgangsperiode. Hvis ikke så er dette en symlink som peker til samme sertifikat som over.
ADD --chmod=644 https://yum.spk.no/pub/pki/spk-root-ca-previous.pem /usr/local/share/ca-certificates/

# Installerer rotsertifikater
RUN apk --no-cache update && \
    apk --no-cache add ca-certificates && \
    update-ca-certificates

USER user
