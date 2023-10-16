#!/usr/bin/env bash

# 传参
KOYEB_ACCOUNT=
KOYEB_PASSWORD=

# 两个变量不全则不运行保活
check_variable() {
  [[ -z "${KOYEB_ACCOUNT}" || -z "${KOYEB_ACCOUNT}" ]] && exit
}

# 开始保活
run() {
while true
do
  curl -sX POST https://app.koyeb.com/v1/account/login -H 'Content-Type: application/json' -d '{"email":"'"${KOYEB_ACCOUNT}"'","password":"'"${KOYEB_PASSWORD}"'"}'
  rm -rf /dev/null
  sleep 432000
done
}
check_variable
run
