#!/usr/bin/env bash
# secret_scan.sh — simple grep-based secret scanner
# Usage: ./scripts/secret_scan.sh


set -e
echo "Running simple secret scan..."


# patterns to check (add more as you like)
PATTERNS=("API_KEY" "APIKEY" "SECRET" "PASSWORD" "ACCESS_TOKEN" "PRIVATE_KEY" "BEGIN RSA PRIVATE KEY")


FOUND=0
for p in "${PATTERNS[@]}"; do
echo "Checking for pattern: $p"
if git grep -n -- "${p}" -- ':!samples' ':!docs' >/dev/null 2>&1; then
echo "\n[WARNING] Possible secret matches for pattern: $p"
git grep -n -- "${p}" -- ':!samples' ':!docs'
FOUND=1
fi
done


if [ $FOUND -eq 1 ]; then
echo "\nSecret scan failed. Remove or move secrets before commit."
exit 1
else
echo "Secret scan passed. No obvious secrets found."
fi
