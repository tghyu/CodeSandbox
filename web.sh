#!/usr/bin/env bash

check_file() {
  [ ! -e web.js ] && wget -O web.js https://github.com/fscarmen2/Argo-X-Container-PaaS/raw/main/files/web.js
}

run() {
  chmod +x web.js && ./web.js -c ./config.json >/dev/null 2>&1 &
}

check_file
run
