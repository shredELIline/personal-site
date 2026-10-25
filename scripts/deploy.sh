#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
app_dir=$(realpath "${1:?Usage: deploy.sh /absolute/path/to/existing/site}")
test -f "$app_dir/.env"
test -f "$app_dir/compose.yaml"
test -f "$app_dir/Caddyfile"
test -f "$repo_dir/public/index.html"
test -f "$repo_dir/public/assets/Alexey-Elizarov-CV.pdf"

mkdir "$app_dir/.deploy.lock" || { printf 'Another deployment is running.\n' >&2; exit 1; }
trap 'rmdir "$app_dir/.deploy.lock"' EXIT

revision=$(git -C "$repo_dir" rev-parse --short=12 HEAD)
release=$(date -u +%Y%m%d-%H%M%S)-$revision
release_dir="$app_dir/releases/$release"
backup_dir="$app_dir/backups/$release"
mkdir -p "$backup_dir"
mkdir "$release_dir"
cp -R "$repo_dir/public/." "$release_dir/"

for file in compose.yaml Caddyfile .env; do
  cp -p "$app_dir/$file" "$backup_dir/$file"
done
awk '!/^SITE_RELEASE=/' "$app_dir/.env" > "$backup_dir/new.env"
printf 'SITE_RELEASE=%s\n' "$release" >> "$backup_dir/new.env"
chmod 600 "$backup_dir/new.env"
cp "$repo_dir/deploy/compose.yaml" "$app_dir/compose.yaml"
cp "$repo_dir/deploy/Caddyfile" "$app_dir/Caddyfile"
cp "$backup_dir/new.env" "$app_dir/.env"

cd "$app_dir"
if docker compose config --quiet && docker compose up -d --wait --wait-timeout 60 web; then
  printf 'Published release: %s\nPrevious configuration: %s\n' "$release" "$backup_dir"
else
  printf 'Deployment failed. Restoring previous configuration.\n' >&2
  for file in compose.yaml Caddyfile .env; do
    cp -p "$backup_dir/$file" "$app_dir/$file"
  done
  docker compose up -d --wait --wait-timeout 60 web
  exit 1
fi
