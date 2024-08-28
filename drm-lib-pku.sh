#!/bin/bash
set -xe

JSESSIONID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
FID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
FILENAME="xxxxxxxx.pdf"

i=0
while true
do
    URL="https://drm.lib.pku.edu.cn/jumpServlet?page=${i}&fid=${FID}&userid=&filename=${FILENAME}&visitid="
    response=$(curl -s "$URL" -H "Cookie: JSESSIONID=${JSESSIONID}")
    http_code=$?

    if [ $http_code -ne 0 ]; then
        echo "Curl command failed with exit code: $http_code. Stopping."
        break
    fi

    echo "$response" >> a.json

    if [ -z "$response" ]; then
        echo "Received empty response. Stopping."
        break
    fi

    i=$((i+1))
done

jq -r '.list[] | "\(.id) \(.src)"' all.json |
    while IFS=' ' read -r id src; do
        echo "Processing ID: $id with SRC: $src"
        curl "${src}" -H "Cookie: JSESSIONID=${JSESSIONID}" -o "${id}.jpg"
    done

