# rustdesk-apt-repo-latest

[![Create Repo for RustDesk latest](https://github.com/xlionjuan/rustdesk-apt-repo-latest/actions/workflows/latest.yml/badge.svg)](https://github.com/xlionjuan/rustdesk-apt-repo-latest/actions/workflows/latest.yml)

> [!IMPORTANT]  
> This is ***unofficial*** [RustDesk](https://github.com/rustdesk/rustdesk/) apt repo, what I can say is *trust me bro*, it is your decision to trust me or not.

> [!NOTE]  
> You're viewing **latest** channel, [click me to check **Nightly** channel.](https://github.com/xlionjuan/rustdesk-apt-repo-nightly)

> [!NOTE]  
> This repo also contains [RustDesk Server suite](https://github.com/rustdesk/rustdesk-server) including hbbr, hbbs, utils, though I personality recommand to use [Docker 🐋 ](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/ubuntu-server/docker/).

> [!NOTE]  
> Same thing but [RPM](https://github.com/xlionjuan/rustdesk-rpm-repo) is also available.

> [!NOTE]  
> Cloudflare R2 source is deprecated, but it will still available for some time.

This repo will use modified version of [morph027/apt-repo-action](https://github.com/xlionjuan/apt-repo-action) and [xlionjuan/fedora-createrepo-image](https://github.com/xlionjuan/fedora-createrepo-image) to create repo, and deploy to GitHub Pages.

The `.sh` script is written by ChatGPT, it will fetch the release data from GitHub API and use [jq](https://github.com/jqlang/jq) to parse JSON data and find the asset URL.

## Architectures

This repo provides following architectures

* `amd64`  (x86_64)
* `arm64`  (aarch64)
* `armhf`  (armv7)
* `i386`   (x86_32) (Only on [RustDesk Server](https://github.com/rustdesk/rustdesk-server))

And `armhf` only has sciter verion.

## Update frequency

* Nightly: Every 3 AM UTC, because RustDesk's Nightly will build a little over 2 hours.
* latest: Every Saturday

## Add this repo
### Add GPG key

Please install [xlion-repo-archive-keyring](https://github.com/xlionjuan/xlion-repo-archive-keyring) package, you need to have `jq` and `curl` installed, this command will query GitHub API to get letest keyring package and install it. If you're mind installing by this way, please go to [its releases](https://github.com/xlionjuan/xlion-repo-archive-keyring/releases) and verify it with SHA256.

```
sudo apt-get update && sudo apt-get install -y jq curl && url=$(curl -s https://api.github.com/repos/xlionjuan/xlion-repo-archive-keyring/releases/latest | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url') && tmpfile="/tmp/$(basename "$url")" && curl -L "$url" -o "$tmpfile" && sudo dpkg -i "$tmpfile"
```

### Add apt source

```bash
curl -fsSL https://xlionjuan.github.io/rustdesk-apt-repo-latest/latest.sources | sudo tee /etc/apt/sources.list.d/xlion-rustdesk-repo.sources
```

<details>
<summary>GitLab Pages...</summary>
<br>

Because of terrible Fastly CDN, you may want another choices, import the GitHub Pages' sources first, than run this command.

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
