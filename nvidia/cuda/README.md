# NVIDIA CUDA + remodev

`ghcr.io/fr4nk1incs/docker-images/nvidia/cuda` (amd64, cudnn-devel variants):

- `cuda-12.8.1-cudnn-devel-ubuntu22.04`
- `cuda-12.8.1-cudnn-devel-ubuntu24.04`
- `cuda-13.0.3-cudnn-devel-ubuntu22.04`
- `cuda-13.0.3-cudnn-devel-ubuntu24.04`
- `cuda-13.2.1-cudnn-devel-ubuntu22.04`
- `cuda-13.2.1-cudnn-devel-ubuntu24.04`
- each also tagged `...-sha-<commit>`

```sh
docker run --rm -it --gpus all -v "$PWD:/workspace" \
  ghcr.io/fr4nk1incs/docker-images/nvidia/cuda:cuda-12.8.1-cudnn-devel-ubuntu24.04
```

Zsh by default, workdir `/workspace`, `/root` is a remodev clone.

## SSH

Mount a public key and start sshd:

```sh
IMAGE=ghcr.io/fr4nk1incs/docker-images/nvidia/cuda:cuda-12.8.1-cudnn-devel-ubuntu24.04
docker run -d -p 2222:22 -v ~/.ssh/id_ed25519.pub:/root/.ssh/authorized_keys:ro \
  "$IMAGE" bash -c 'ssh-keygen -A && mkdir -p /run/sshd && exec /usr/sbin/sshd -D -e'
ssh -p 2222 root@localhost
```

## Configure

- `docker-bake.hcl` — `DISTROS` × `CUDA_VERSIONS` matrix
- `Dockerfile` — base image, apt packages, shell, sshd, and the remodev install (`GITHUB_TOKEN` enters as a BuildKit secret mount, never a layer)

## Build

```sh
GITHUB_TOKEN=$(gh auth token) docker buildx bake \
  -f nvidia/cuda/docker-bake.hcl cuda-12-8-1-cudnn-devel-ubuntu24-04 --load
```
