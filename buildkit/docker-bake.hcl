variable REGISTRY {
  default = "cr.spk.no"
}

variable PROJECT {
  default = "infra"
}

variable TAG {
  default = "local"
}

variable BUILDKIT_IMAGE_TAG {
  default = "v0.21.0" // renovate: docker=docker.io/moby/buildkit
}

target default {
  dockerfile = "Dockerfile"
  context    = "."
  args = {
    BUILDKIT_IMAGE_TAG = BUILDKIT_IMAGE_TAG
    REGISTRY           = REGISTRY
    PROJECT            = PROJECT
    TAG                = TAG
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "${REGISTRY}/${PROJECT}/buildkit:latest",
    "${REGISTRY}/${PROJECT}/buildkit:${TAG}-spk",
    "${REGISTRY}/${PROJECT}/buildkit:${BUILDKIT_IMAGE_TAG}.${TAG}-spk"
  ]
}
