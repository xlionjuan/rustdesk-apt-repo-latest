#!/bin/bash

set -oue pipefail

# Define the repository you want to fetch
REPO="rustdesk/rustdesk-server"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Fetch the release data using curl
RELEASE_DATA=$(curl --retry 12 --retry-all-errors -s "$API_URL")
wait

# Check if RELEASE_DATA contains "browser_download_url"
if ! echo "$RELEASE_DATA" | grep -q "browser_download_url"; then
    echo "'browser_download_url' not found in release data. Please check the repository/tag name or API response."
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

wget $DEB_URLS
