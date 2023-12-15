#!/bin/bash

## REMOVE CACHE

rm -rf ../target

## BUILD

sozo build

echo "Build successful."
# Set the path to your manifest.json file
manifest_file="../target/dev/manifest.json"

## FIX PADDING

# Check if the file exists
if [ ! -f "$manifest_file" ]; then
    echo "Error: File not found: $manifest_file"
    exit 1
fi

# Backup the original file
cp "$manifest_file" "$manifest_file.bak"

# Use jq to update the "class_hash" fields
jq '.models |= map(.class_hash |= ("0x" + "0" * (64 - (. | length - 2)) + .[2:]))' "$manifest_file" > tmp_manifest.json && mv tmp_manifest.json "$manifest_file"

echo "Replacement complete. Backup created at $manifest_file.bak"

