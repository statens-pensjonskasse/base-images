group default {
  targets = [
    "rockylinux-9-minimal"
  ]
}

variable REGISTRY {
  default = "ghcr.io/statens-pensjonskasse"
}

variable PROJECT {
  default = "base"
}

variable TAG {
  default = ""
}

variable OS_NAMES {
  default = ["rockylinux"]
}

variable OS_VERSIONS {
  default = [9]
}

variable OS_VARIANTS {
  default = ["-minimal"]
}

target os {
  name       = "${OS_NAME}-${OS_VERSION}${OS_VARIANT}"
  dockerfile = "Dockerfile"
  context    = "."
  matrix = {
    OS_NAME    = OS_NAMES
    OS_VERSION = OS_VERSIONS
    OS_VARIANT = OS_VARIANTS
  }
  args = {
    OS_VERSION          = OS_VERSION
    BASE_IMAGE          = "cr.spk.no/docker-hub/${OS_NAME}:${OS_VERSION}${OS_VARIANT}"
    PACKAGE_MANAGER     = equal(OS_VARIANT, "") ? "dnf" : "microdnf"
    REGISTRY            = REGISTRY
    PROJECT             = PROJECT
    TAG                 = TAG
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
      equal(TAG, "") ? "${PROJECT}/${OS_NAME}:${OS_VERSION}${OS_VARIANT}-local" : "",
      notequal(TAG, "") ? "${REGISTRY}/${PROJECT}/${OS_NAME}:${OS_VERSION}${OS_VARIANT}" : "",
      notequal(TAG, "") ? "${REGISTRY}/${PROJECT}/${OS_NAME}:${OS_VERSION}.${TAG}${OS_VARIANT}" : "",
  ]
}
