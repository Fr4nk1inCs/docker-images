# syntax=docker/dockerfile:1
# check=skip=InvalidDefaultArgInFrom;error=true
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

USER root
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN <<'EOF'
  set -eu
  apt-get update
  apt-get install -y --no-install-recommends \
      git curl ca-certificates xz-utils locales \
      zsh tmux rsync zip jq \
      build-essential clangd cmake ninja-build pkg-config libssl-dev \
      python3 python3-venv python3-pip \
      openssh-client openssh-server
  echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
  locale-gen
  rm -rf /var/lib/apt/lists/*
  chsh -s /usr/bin/zsh root
EOF

RUN <<'EOF'
  CONF=/etc/ssh/sshd_config.d/remodev.conf
  echo 'PermitRootLogin prohibit-password' >> $CONF
  echo 'PasswordAuthentication no'         >> $CONF
EOF

ARG REMODEV_REPOSITORY=https://github.com/Fr4nk1inCs/remodev
RUN --mount=type=secret,id=github_token bash -euo pipefail <<'EOF'
  export GITHUB_TOKEN="$(cat /run/secrets/github_token 2>/dev/null || true)"

  rm -rf /root
  git clone "$REMODEV_REPOSITORY" /root

  curl https://mise.run | sh
  /root/.local/bin/mise up

  eval "$(/root/.local/bin/mise activate bash --shims)"

  TERM=xterm-256color zsh -ic 'exit'
  test -s /root/.zim/init.zsh
  nvim --headless '+Lazy! sync' +qa

  rm -rf /root/.cache /root/.npm/_cacache /root/.cargo/registry /root/.cargo/git
EOF

WORKDIR /workspace
CMD ["/bin/zsh"]
