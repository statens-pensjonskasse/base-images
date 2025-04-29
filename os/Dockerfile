ARG BASE_IMAGE=rockylinux:9-minimal
FROM ${BASE_IMAGE}

# Magisk variabel som blir satt til amd64 for linux/amd64 platform og arm64 for linux/arm64 platform
ARG TARGETARCH

ARG OS_VERSION=9

ARG PACKAGE_MANAGER=microdnf
ARG PACKAGE_MANAGER_FLAGS='-y --nodocs'

# Set tidssone
ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone

# Fjern mirrors og bruk baseurl (mest for Rocky Linux) for repos
RUN sed -i '/^mirrorlist/d' /etc/yum.repos.d/*.repo && \
    sed -i 's/^#baseurl/baseurl/' /etc/yum.repos.d/*.repo

RUN --mount=type=bind,src=repo-files/docker.repo.tmpl,dst=/tmp/docker.repo.tmpl \
    --mount=type=bind,src=repo-files/microsoft.repo.tmpl,dst=/tmp/microsoft.repo.tmpl \
    --mount=type=bind,src=repo-files/spk.repo.tmpl,dst=/tmp/spk.repo.tmpl \
    --mount=type=bind,src=repo-files/spk-epel.repo.tmpl,dst=/tmp/spk-epel.repo.tmpl \
    --mount=type=bind,src=repo-files/spk-no-el-dep.repo.tmpl,dst=/tmp/spk-no-el-dep.repo.tmpl \
    --mount=type=bind,src=repo-files/zulu-openjdk.repo.tmpl,dst=/tmp/zulu-openjdk.repo.tmpl \
    if [ "${TARGETARCH}" = "amd64" ]; then ARCH=x86_64; \
    elif [ "${TARGETARCH}" = "arm64" ]; then ARCH=aarch64 ; \
    else echo "Målarkitektur '${TARGETARCH}' er ikke støttet" && exit 1; \
    fi; \
    OS_VERSION="${OS_VERSION}"; \
    eval "echo \"$(cat /tmp/docker.repo.tmpl)\"" > /etc/yum.repos.d/docker-el${OS_VERSION}.repo; \
    eval "echo \"$(cat /tmp/microsoft.repo.tmpl)\"" > /etc/yum.repos.d/microsoft-el${OS_VERSION}.repo; \
    eval "echo \"$(cat /tmp/spk.repo.tmpl)\"" > /etc/yum.repos.d/spk-el${OS_VERSION}.repo; \
    eval "echo \"$(cat /tmp/spk-epel.repo.tmpl)\"" > /etc/yum.repos.d/spk-epel${OS_VERSION}.repo; \
    eval "echo \"$(cat /tmp/spk-no-el-dep.repo.tmpl)\"" > /etc/yum.repos.d/spk-no-el-dep.repo; \
    eval "echo \"$(cat /tmp/zulu-openjdk.repo.tmpl)\"" > /etc/yum.repos.d/zulu-openjdk.repo;

# Henter gjeldende rotsertifikat fra yum-server
ADD --chmod=644 https://yum.spk.no/pub/pki/spk-root-ca-current.pem /etc/pki/ca-trust/source/anchors/
# Henter gammelt rotsertifikat hvis vi er i en overgangsperiode. Hvis ikke så er dette en symlink som peker til samme sertifikat som over.
ADD --chmod=644 https://yum.spk.no/pub/pki/spk-root-ca-previous.pem /etc/pki/ca-trust/source/anchors/

# Installerer rotsertifikater
RUN update-ca-trust extract

# Oppdater pakker
RUN ${PACKAGE_MANAGER} ${PACKAGE_MANAGER_FLAGS} update && \
    ${PACKAGE_MANAGER} clean all && \
    rm -rf /var/cache/yum
