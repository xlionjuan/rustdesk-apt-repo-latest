#!/bin/bash

# Define the repository and the tag you want to fetch
REPO="rustdesk/rustdesk"
#TAG="latest"  # Change this to any tag you want
#API_URL="https://api.github.com/repos/$REPO/releases/tags/$TAG"
API_URL="https://api.github.com/repos/$REPO/releases/latest"
# Fetch the release data for the specified tag using curl
RELEASE_DATA=$(curl --retry 3 -s "$API_URL")

# Check if RELEASE_DATA is not empty
if [ -z "$RELEASE_DATA" ]; then
    echo "Failed to fetch release data. Please check your internet connection or the repository/tag name."
    exit 1
fi

# Use jq to parse JSON data and find the asset URL
RUSTDESK_URL_AMD64=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("x86_64") and endswith(".deb") and (contains("sciter") | not)) | .browser_download_url' | head -n 1)
RUSTDESK_URL_ARM64=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("aarch64") and endswith(".deb") and (contains("sciter") | not)) | .browser_download_url' | head -n 1)
RUSTDESK_URL_ARMHF=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | contains("armv7") and endswith(".deb")) | .browser_download_url' | head -n 1)
# armhf is ARMv7, and only has sciter version.

# Check if the asset URL was found
#if [ -z "$RUSTDESK_URL" ]; then
#    echo "No matching file found."
#else
#    echo "RUSTDESK_URL=\"$RUSTDESK_URL\""
#fi

echo "--------------------RESULT--------------------"
echo "RUSTDESK_URL_AMD64=\"$RUSTDESK_URL_AMD64\""
echo "RUSTDESK_URL_ARM64=\"$RUSTDESK_URL_ARM64\""
echo "RUSTDESK_URL_ARMHF=\"$RUSTDESK_URL_ARMHF\""
echo ""
echo "------------------DOWNLOADING-----------------"
#wget $RUSTDESK_URL_AMD64
#wget $RUSTDESK_URL_ARM64
#wget $RUSTDESK_URL_ARMHF
wget https://github.com/rustdesk/rustdesk/releases/download/1.3.0/rustdesk-1.3.0-x86_64.deb
wget https://github.com/rustdesk/rustdesk/releases/download/1.3.0/rustdesk-1.3.0-aarch64.deb
wget https://github.com/rustdesk/rustdesk/releases/download/1.3.0/rustdesk-1.3.0-armv7-sciter.deb