#!/bin/bash

set -oue pipefail

# Define the repository you want to fetch
REPO="rustdesk/rustdesk-server"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Fetch the release data using curl
RELEASE_DATA=$(curl --retry 3 -s "$API_URL")

# Check if RELEASE_DATA is not empty
if [ -z "$RELEASE_DATA" ]; then
    echo "Failed to fetch release data. Please check your internet connection or the repository name."
    exit 1
fi

# Use jq to parse JSON data and find all .deb asset URLs
DEB_URLS=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url')

echo "-----------------RUSTDESK SERVER-----------------"
echo "--------------DEB FILES TO DOWNLOAD--------------"
echo ""
echo "$DEB_URLS"
echo ""
echo "-------------------DOWNLOADING------------------"

wget "$DEB_URLS"
