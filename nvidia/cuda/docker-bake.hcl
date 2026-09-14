# Native Bake matrix: every distro is combined with every CUDA release.
variable "DISTROS" {
  default = ["ubuntu22.04", "ubuntu24.04"]
}

variable "CUDA_VERSIONS" {
  default = ["12.8.1", "13.0.3", "13.2.1"]
}

# GHCR repo in CI; the default keeps local builds out of any registry namespace
variable "REPO" {
  default = "remodev/cuda"
}

# extra tag suffix per image (CI adds the commit)
variable "TAG_SUFFIX" {
  default = ""
}

group "default" {
  targets = ["cuda"]
}

target "cuda" {
  name = "cuda-${replace(cuda, ".", "-")}-cudnn-devel-${replace(distro, ".", "-")}"
  matrix = {
    distro = DISTROS
    cuda = CUDA_VERSIONS
  }
  context = "nvidia/cuda"
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64"]
  tags = concat(
    ["${REPO}:cuda-${cuda}-cudnn-devel-${distro}"],
    TAG_SUFFIX == "" ? [] : ["${REPO}:cuda-${cuda}-cudnn-devel-${distro}-${TAG_SUFFIX}"]
  )
  args = {
    BASE_IMAGE = "nvidia/cuda:${cuda}-cudnn-devel-${distro}"
  }
  # mise install needs GitHub API auth against rate limits; the Dockerfile
  # reads it as a secret mount so it never lands in image history
  secret = [
    { type = "env", id = "github_token", env = "GITHUB_TOKEN" }
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/Fr4nk1inCs/docker-images"
    "org.opencontainers.image.base.name" = "nvidia/cuda:${cuda}-cudnn-devel-${distro}"
  }
}
