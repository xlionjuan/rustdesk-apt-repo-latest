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
Nightly and latest are sharing same GPG key.
```
curl -fsSL https://raw.githubusercontent.com/xlionjuan/rustdesk-apt-repo-nightly/refs/heads/main/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/xlion-repo.gpg
```

### Add apt source
#### For Ubuntu 24 / Debian 12 or latter (Deb822 style format)

```bash
sudo tee /etc/apt/sources.list.d/xlion-rustdesk-repo.sources << EOF
# Change "latest" to "nightly" if you want to switch channel
Types: deb
URIs: https://xlionjuan.github.io/rustdesk-apt-repo-latest
Suites: main
Components: main
Signed-By: /usr/share/keyrings/xlion-repo.gpg
EOF
```

#### For older version

```bash
sudo tee /etc/apt/sources.list.d/xlion-rustdesk-repo.list << EOF
# Change "latest" to "nightly" if you want to switch channel
deb [signed-by=/usr/share/keyrings/xlion-repo.gpg] https://xlionjuan.github.io/rustdesk-apt-repo-latest main main
EOF
```

> [!NOTE]  
> Deb822 style format are designed for more human readable, older style format will still supported on newer systems.

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

## FAQ
### ***Not needed anymore, just enable i386 support in the repo, no any packages in it is fine.***
### ~~I got i386 error~~

~~If you got the warning like this~~
```
N: Skipping acquire of configured file 'main/binary-i386/Packages' as repository 'https://xlionjuan.github.io/rustdesk-apt-repo-latest main InRelease' doesn't support architecture 'i386'
```
~~This is because you enabled `i386`(32bit) on your apt, mainly because you're a developer or you have installed Steam 32bit library, you can ignore this, but it is annoying! Let's fix this~~

#### ~~Deb822~~
~~Uncomment the line with `Architectures:`~~

#### ~~Older style~~
~~Comment the line starts with `deb`, and uncomment the line that has `arch=amd64`~~
