#!/usr/bin/env bash

set -euo pipefail

upstream_url="${UPSTREAM_URL:-https://github.com/SynchronetBBS/sbbs.git}"
upstream_branch="${UPSTREAM_BRANCH:-master}"
upstream_remote="${UPSTREAM_REMOTE:-upstream-sbbs}"

sources=(
	"src/conio/utf8_codepages.c"
	"src/conio/utf8_codepages.h"
	"src/encode/base64.c"
	"src/encode/base64.h"
)
destinations=(
	"utf8_codepages.c"
	"utf8_codepages.h"
	"base64.c"
	"base64.h"
)

fail() {
	printf '::error title=Synchronet support-file sync failed::%s\n' "$*" >&2
	exit 1
}

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
	|| fail "Run this script from a DeuceGate Git checkout"

if test -n "$(git status --porcelain)"; then
	fail "The checkout is not clean; commit or stash changes before syncing"
fi

if git remote get-url "$upstream_remote" >/dev/null 2>&1; then
	git remote set-url "$upstream_remote" "$upstream_url"
else
	git remote add "$upstream_remote" "$upstream_url"
fi

printf 'Fetching %s branch %s (without tags)...\n' \
	"$upstream_url" "$upstream_branch"
git fetch --no-tags --prune "$upstream_remote" \
	"+refs/heads/${upstream_branch}:refs/remotes/${upstream_remote}/${upstream_branch}"

upstream_ref="refs/remotes/${upstream_remote}/${upstream_branch}"
sync_tmp="$(mktemp -d "${TMPDIR:-/tmp}/deucegate-sync.XXXXXX")"
trap 'rm -rf "$sync_tmp"' EXIT
changed=0

for i in "${!sources[@]}"; do
	source_path="${sources[$i]}"
	destination="${destinations[$i]}"
	git cat-file -e "${upstream_ref}:${source_path}" 2>/dev/null \
		|| fail "${source_path} does not exist at ${upstream_ref}"
	git show "${upstream_ref}:${source_path}" > "${sync_tmp}/${i}"
	if ! cmp -s "${sync_tmp}/${i}" "$destination"; then
		install -m 0644 "${sync_tmp}/${i}" "$destination"
		printf 'Updated %s from %s.\n' "$destination" "$source_path"
		changed=1
	fi
done

if test "$changed" -eq 0; then
	printf 'Tracked Synchronet support files are already current.\n'
fi
