#!/bin/bash

set -oue pipefail

CURRENT_DIR="$(pwd)"
SOURCE_DIR="$(pwd)/ori" # Directory containing the original .deb files

# Iterate over all .deb files in the source directory
for deb_file in "$SOURCE_DIR"/*.deb; do
    if [ -f "$deb_file" ]; then
        {
            echo "Processing: $deb_file"

            fpm -t deb -s deb \
                --deb-compression xz --deb-recommends xlion-repo-archive-keyring\
                -p $PWD "$deb_file"

            # Remove the original file after processing
            rm -f "$deb_file"
        } &
    else
        echo "Skipping: $deb_file"
    fi
done

# Wait for all parallel tasks to complete
wait

echo "Repackage works are done, all modified files are in: $CURRENT_DIR"
echo "Cleanup......."
rm -r "$SOURCE_DIR"
echo "Run ls"
ls
