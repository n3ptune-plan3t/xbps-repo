#!/usr/bin/env bash
#
# changed_templates.sh

set -euo pipefail

: > /tmp/old_pkgs
: > /tmp/new_pkgs

repo="${GITHUB_REPOSITORY:-$(git config --get remote.origin.url | sed -E 's#.*github.com[:/]([^/]+/[^/.]+)(\.git)?#\1#')}"

echo "Old pkgs:"
gh release view latest --repo "$repo" \
	--json assets --jq '.assets[].name' 2>/dev/null | sed \
	's/\.x86_64\.xbps//' | rg -v 'x86_64-repodata|sig2' | tee \
	/tmp/old_pkgs || true

echo "New pkgs:"
for pkgdir in srcpkgs/*; do
	[ -d "$pkgdir" ] || continue
	[ -f "$pkgdir/template" ] || continue
	pkg=$(basename "$pkgdir")
	ver=$(rg "^version=" "$pkgdir/template" | awk -F= '{ print $2 }')
	rev=$(rg "^revision=" "$pkgdir/template" | awk -F= '{ print $2 }')
	echo -e "$pkg-${ver}_$rev" | tee -a /tmp/new_pkgs
done

sort /tmp/new_pkgs -o /tmp/new_pkgs
sort /tmp/old_pkgs -o /tmp/old_pkgs

echo -e '\x1b[32mChanged packages:\x1b[0m'
comm -13 /tmp/old_pkgs /tmp/new_pkgs |
	sed 's/-[^-]*$//' |
	tee /tmp/templates |
	sed "s/^/  /" >&2
