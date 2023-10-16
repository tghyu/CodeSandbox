#!/usr/bin/env bash

# 传参
PAAS1_URL=
PAAS2_URL=
PAAS3_URL=
PAAS4_URL=
PAAS5_URL=
PAAS6_URL=

# 判断变量并保活

if [[ -z "${PAAS1_URL}" && -z "${PAAS2_URL}" && -z "${PAAS3_URL}" && -z "${PAAS4_URL}" && -z "${PAAS5_URL}" && -z "${PAAS6_URL}" ]]; then
    echo "所有变量都不存在，程序退出。"
    exit 1
fi

function handle_error() {
    # 处理错误函数
    echo "连接超时"
    sleep 10
}

while true; do
    for var in 1 2 3 4 5 6
    do
        url_var="PAAS${var}_URL"
        url=${!url_var}
        if [[ -n "${url}" ]]; then
            count=0
            while true; do
                curl --connect-timeout 10 "${url}" || handle_error
                    break
            done
        fi
    done
    sleep 240
done
