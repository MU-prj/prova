# Toolchain Roblox per `docker run` puro: rojo + stylua + selene, niente Studio.
# Versioni allineate a rokit.toml. Il repo si monta come volume, non si copia.
#
#   docker build -t prova-dev .
#   docker run --rm -v "$PWD":/work -w /work prova-dev make build
#   docker run --rm -v "$PWD":/work -w /work prova-dev make check
#   # serve per Studio (Studio sul tuo PC si collega a localhost:34872):
#   docker run --rm -it -p 34872:34872 -v "$PWD":/work -w /work prova-dev \
#       rojo serve default.project.json --address 0.0.0.0
FROM debian:bookworm-slim

ARG ROJO_VERSION=7.6.1
ARG STYLUA_VERSION=2.3.0
ARG SELENE_VERSION=0.29.0

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl unzip make git; \
    rm -rf /var/lib/apt/lists/*; \
    cd /tmp; \
    fetch() { curl -fsSL -o t.zip "$1"; unzip -o t.zip; rm t.zip; }; \
    fetch "https://github.com/rojo-rbx/rojo/releases/download/v${ROJO_VERSION}/rojo-${ROJO_VERSION}-linux-x86_64.zip"; \
    fetch "https://github.com/JohnnyMorganz/StyLua/releases/download/v${STYLUA_VERSION}/stylua-linux-x86_64.zip"; \
    fetch "https://github.com/Kampfkarren/selene/releases/download/${SELENE_VERSION}/selene-${SELENE_VERSION}-linux.zip"; \
    install -m 0755 rojo stylua selene /usr/local/bin/; \
    rm -f rojo stylua selene; \
    rojo --version; stylua --version; selene --version

WORKDIR /work
CMD ["make", "help"]
