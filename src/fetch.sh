#!/bin/sh
# Resumable download with retries: fetch.sh URL OUTFILE EXPECTED_BYTES
url="$1"; out="$2"; want="$3"
for i in $(seq 1 60); do
  have=$(stat -c %s "$out" 2>/dev/null || echo 0)
  [ "$have" -ge "$want" ] && { echo "OK $out $have"; exit 0; }
  curl -sS -L --http1.1 -C - --retry 5 --retry-delay 2 -o "$out" "$url" || echo "retry $i (have $have)"
  sleep 1
done
echo "FAILED $out"; exit 1
