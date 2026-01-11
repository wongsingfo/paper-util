#!/bin/bash
set -x

JSESSIONID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
FID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
FILENAME="xxxxxxxx.pdf"

EXISTING_IDS=$(grep -o '"id":"[^"]*"' a.json 2>/dev/null | cut -d'"' -f4 | sort -u || echo "")

fetch_with_retry() {
    local page=$1
    local max_retries=3
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        URL="https://drm.lib.pku.edu.cn/jumpServlet?page=${page}&fid=${FID}&userid=&filename=${FILENAME}&visitid="
        response=$(curl -s "$URL" -H "Cookie: JSESSIONID=${JSESSIONID}")
        http_code=$?

        if [ $http_code -ne 0 ]; then
            echo "Curl failed for page ${page}, attempt $((retry_count + 1))/$max_retries"
            retry_count=$((retry_count + 1))
            sleep 10
            continue
        fi

        if [ -z "$response" ]; then
            echo "Empty response for page ${page}, attempt $((retry_count + 1))/$max_retries"
            echo "We have reached the last page"
            retry_count=$((retry_count + 1))
            return 1
        fi

        if echo "$response" | grep -q "超过最大并发限制数"; then
            echo "Rate limit hit for page ${page}, attempt $((retry_count + 1))/$max_retries"
            retry_count=$((retry_count + 1))
            sleep 10
            continue
        fi

        echo "$response"
        return 0
    done

    echo "Failed to fetch page ${page} after $max_retries attempts"
    exit 1
}

i=0
while true
do
    if echo "$EXISTING_IDS" | grep -qx "$i"; then
        echo "Page $i already exists, skipping"
        i=$((i+1))
        continue
    fi

    response=$(fetch_with_retry $i)
    result=$?

    if [ $result -ne 0 ]; then
        echo "Stopping due to repeated failures at page $i"
        break
    fi

    if [ -z "$response" ]; then
        echo "Received empty response. Stopping."
        break
    fi

    echo "$response" >> a.json

    i=$((i+1))
done

download_with_retry() {
    local id=$1
    local src=$2
    local max_retries=3
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        if [ -f "${id}.jpg" ]; then
            echo "File ${id}.jpg already exists, skipping"
            return 0
        fi

        http_code=$(curl -s -o "${id}.jpg" -w "%{http_code}" "${src}" -H "Cookie: JSESSIONID=${JSESSIONID}")

        if [ "$http_code" -eq 200 ]; then
            echo "Successfully downloaded ${id}.jpg"
            return 0
        else
            echo "Failed to download ${id}.jpg (HTTP $http_code), attempt $((retry_count + 1))/$max_retries"
            rm -f "${id}.jpg"
            retry_count=$((retry_count + 1))
            sleep 2
        fi
    done

    echo "Failed to download ${id}.jpg after $max_retries attempts"
    return 1
}

grep -o '"id":"[^"]*"' a.json | cut -d'"' -f4 | sort -n | while read -r id; do
    src=$(grep -oE "\"src\":\"[^\"]*\"[^}]*\"id\":\"$id\"" a.json | head -n 1 | grep -oE "\"src\":\"[^\"]*\"" | cut -d'"' -f4)
    if [ -n "$id" ] && [ -n "$src" ]; then
        if [ -f "${id}.jpg" ]; then
            echo "File ${id}.jpg already exists, skipping"
        else
            download_with_retry "$id" "$src" || true
        fi
    fi
done

if ls *.jpg 1> /dev/null 2>&1; then
    echo "Merging images into PDF..."
    convert $(ls *.jpg | sort -V) merged.pdf
    echo "PDF created: merged.pdf"
else
    echo "No jpg files found"
fi

