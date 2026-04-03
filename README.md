# Personal XBPS Repository Template

This fork is set up for **personal use**:

- `srcpkgs/` starts empty so you can add only your own package templates.
- CI builds your packages and publishes them to the `latest` release.
- Repository metadata is generated without private signing keys.

## Add your own packages

Create one directory per package in `srcpkgs/`, each containing a `template` file.

Example layout:

```text
srcpkgs/
  my-package/
    template
  my-other-package/
    template
```

## Use this repository on your systems

```bash
echo "repository=https://github.com/<your-user>/<your-repo>/releases/latest/download" | sudo tee /etc/xbps.d/personal-xbps.conf
sudo xbps-install -Su
```

## Notes

- This setup is intentionally unsigned for convenience in personal setups.
- If you later want stronger trust guarantees, you can re-enable package/repository signing in workflows.

## Build your package in GitHub Actions

### Option 1: push-based build (automatic)

1. Add/update templates under `srcpkgs/<pkgname>/template`.
2. Commit and push to your default branch.
3. The **Build Packages** workflow (`.github/workflows/build.yaml`) runs automatically when `srcpkgs/**` changes.

### Option 2: manual selected build

1. Open **Actions** in GitHub.
2. Run **Build Selected XBPS Package**.
3. Provide package names in the `packages` input (comma-separated, e.g. `floorp`).

### Artifacts / release

- CI publishes built `.xbps` packages plus `x86_64-repodata` into the `latest` release.
- To install `floorp` after publishing:

```bash
sudo xbps-install -Su
sudo xbps-install floorp
```
