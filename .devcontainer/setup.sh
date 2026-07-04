#!/usr/bin/env bash
# Prepara il toolchain nel container via npm (come la CI): rojo + stylua.
# Niente Rokit, niente Roblox Studio da installare sul tuo PC.
# selene non e' su npm, quindi scarico il binario dalla release bloccata in rokit.toml.
set -euo pipefail

# rojo + stylua (usati dal Makefile come `npx rojo` / `npx stylua`)
npm ci

# selene: stessa versione di rokit.toml
SELENE_VERSION=0.29.0
if ! command -v selene >/dev/null 2>&1; then
  command -v unzip >/dev/null 2>&1 || { sudo apt-get update && sudo apt-get install -y unzip; }
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/selene.zip" \
    "https://github.com/Kampfkarren/selene/releases/download/${SELENE_VERSION}/selene-${SELENE_VERSION}-linux.zip"
  unzip -o "$tmp/selene.zip" -d "$tmp"
  sudo install -m 0755 "$tmp/selene" /usr/local/bin/selene
  rm -rf "$tmp"
fi

echo "OK. Comandi: make build | make check | make serve"
echo "Per il playtest: apri Roblox Studio sul tuo PC e collega Rojo a localhost:34872."
