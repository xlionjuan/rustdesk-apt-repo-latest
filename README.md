# rustdesk-apt-repo-latest

[![Create Repo for RustDesk latest](https://github.com/xlionjuan/rustdesk-apt-repo-latest/actions/workflows/latest.yml/badge.svg)](https://github.com/xlionjuan/rustdesk-apt-repo-latest/actions/workflows/latest.yml)

> [!IMPORTANT]  
> This is ***unofficial*** [RustDesk](https://github.com/rustdesk/rustdesk/) apt repo, what I can say is *trust me bro*. It is your decision whether to trust me or not.

> [!NOTE]  
> You're viewing **latest** channel, [click me to check **Nightly** channel.](https://github.com/xlionjuan/rustdesk-apt-repo-nightly)

> [!NOTE]  
> This repo also contains [RustDesk Server suite](https://github.com/rustdesk/rustdesk-server) including hbbr, hbbs, utils, though I personality recommand to use [Docker 🐋 ](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/ubuntu-server/docker/).

> [!NOTE]  
> An [RPM](https://github.com/xlionjuan/rustdesk-rpm-repo) version is also available.

> [!NOTE]  
> Cloudflare R2 source is deprecated, but it will still available for some time.

This repo will use [aptly](https://github.com/aptly-dev/aptly) and [xlionjuan/fedora-createrepo-image](https://github.com/xlionjuan/fedora-createrepo-image) to create repo, and deploy to GitHub Pages.

The `.sh` script is written by ChatGPT, it will fetch the release data from GitHub API and use [jq](https://github.com/jqlang/jq) to parse JSON data and find the asset URL.

## Architectures

This repo provides the following architectures

* `amd64`  (x86_64)
* `arm64`  (aarch64)
* `armhf`  (armv7)
* `i386`   (x86_32) (Only on [RustDesk Server](https://github.com/rustdesk/rustdesk-server))

And `armhf` only has sciter version.

## Update frequency

* Nightly: Every 3 AM UTC, because RustDesk's Nightly builds take a little over 2 hours.
* latest: Every Saturday

## Add this repo
### Add GPG key

Please install [xlion-repo-archive-keyring](https://github.com/xlionjuan/xlion-repo-archive-keyring) package, you need to have `jq` and `curl` installed, this command will query GitHub API to get latest keyring package, verify its SHA256 and install it.

```bash
sudo apt-get update && sudo apt-get install -y jq curl && json="$(curl -fsSL https://api.github.com/repos/xlionjuan/xlion-repo-archive-keyring/releases/latest)" && asset="$(echo "$json" | jq -r '.assets[] | select(.name | endswith(".deb")) | "\(.browser_download_url) \(.digest)"' | head -n1)" && url="${asset%% *}" && digest="${asset##* }" && [ -n "$url" ] && [ "$url" != "null" ] && [ -n "$digest" ] && [ "$digest" != "null" ] || { echo "ERROR: cannot locate .deb asset or SHA256 digest" >&2; return 1 2>/dev/null || false; } && tmpfile="$(mktemp /tmp/xlion-keyring-XXXXXX.deb)" && curl -fL "$url" -o "$tmpfile" || { echo "ERROR: download failed" >&2; return 1 2>/dev/null || false; } && expected="${digest#*:}" && actual="$(sha256sum "$tmpfile" | awk '{print $1}')" && [ "$actual" = "$expected" ] || { echo "ERROR: SHA256 mismatch" >&2; rm -f "$tmpfile"; return 1 2>/dev/null || false; } && sudo dpkg -i "$tmpfile" && rm -f "$tmpfile"
```

### Add apt source

`.sources` format is supported on all systems.

```bash
curl -fsSL https://xlionjuan.github.io/rustdesk-apt-repo-latest/latest.sources | sudo tee /etc/apt/sources.list.d/xlion-rustdesk-repo.sources
```

<details>
<summary>GitLab Pages...</summary>
<br>

Because of terrible Fastly CDN, you may want another choice, import the GitHub Pages' sources first, then run this command.

```bash
sed -i 's/github/gitlab/g' /etc/apt/sources.list.d/xlion-rustdesk-repo.sources
```
</details>

## Install/Upgrade RustDesk/RustDesk Server

### For RustDesk
```bash
sudo apt update && sudo apt install rustdesk
```

### For RustDesk Server
```bash
sudo apt update && sudo apt install rustdesk-server
```

`rustdesk-server` is a metapackage that will install `rustdesk-server-hbbr`, `rustdesk-server-hbbs`, `rustdesk-server-utils` all in once!

## License

This repository is intended for distributing software. Unless otherwise specified, all scripts and configurations are licensed under the [GNU AGPLv3](LICENSE). **THIS DOES NOT INCLUDE THE DISTRIBUTED SOFTWARE ITSELF**. For the licenses of the distributed software, please refer to the software developers' websites, Git repositories, the packages' metadata, or contact the developers directly if you have any questions.
