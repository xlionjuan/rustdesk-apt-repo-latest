#!/bin/bash

set -oue pipefail

# Define the repository and the tag you want to fetch
REPO="rustdesk/rustdesk"
#TAG="latest"  # Change this to any tag you want
#API_URL="https://api.github.com/repos/$REPO/releases/tags/$TAG"
API_URL="https://api.github.com/repos/$REPO/releases/latest"
# Fetch the release data for the specified tag using curl
RELEASE_DATA=$(curl --retry 12 --retry-all-errors -s "$API_URL")
wait

# Check if RELEASE_DATA contains "browser_download_url"
if ! echo "$RELEASE_DATA" | jq -e '.assets[]? | select(.browser_download_url? != null)' > /dev/null; then
    echo "'browser_download_url' not found in release data. Please check the repository/tag name or API response."
    exit 1
fi

# Use jq to parse JSON data and find the asset URL
RUSTDESK_URL_AMD64=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("x86_64") and endswith(".deb") and (contains("sciter") | not)) | .browser_download_url' | head -n 1)
RUSTDESK_URL_ARM64=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("aarch64") and endswith(".deb") and (contains("sciter") | not)) | .browser_download_url' | head -n 1)
RUSTDESK_URL_ARMHF=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("armv7") and endswith(".deb")) | .browser_download_url' | head -n 1)
# armhf is ARMv7, and only has sciter version.


echo "--------------------RESULT--------------------"
echo "RUSTDESK_URL_AMD64=\"$RUSTDESK_URL_AMD64\""
echo "RUSTDESK_URL_ARM64=\"$RUSTDESK_URL_ARM64\""
echo "RUSTDESK_URL_ARMHF=\"$RUSTDESK_URL_ARMHF\""
echo ""
echo "------------------DOWNLOADING-----------------"
wget "$RUSTDESK_URL_AMD64" "$RUSTDESK_URL_ARM64" "$RUSTDESK_URL_ARMHF"
