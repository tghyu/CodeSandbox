#!/usr/bin/env bash

ARGO_AUTH={"AccountTag":"3b44ace093045100e0bcf180acddc5bc","TunnelSecret":"hYSa6YcAEiMEVPu0JNEI+HpGkioWHXeIABBSNuWp8j0=","TunnelID":"95816aa8-9ce9-42d5-bea3-ca681eb86010"}
ARGO_DOMAIN=vercel.andmins.tk

# 下载并运行 Argo
check_file() {
  [ ! -e cloudflared ] && wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && chmod +x cloudflared
}

run() {
  if [[ -n "${ARGO_AUTH}" && -n "${ARGO_DOMAIN}" ]]; then
    [[ "$ARGO_AUTH" =~ TunnelSecret ]] && echo "$ARGO_AUTH" | sed 's@{@{"@g;s@[,:]@"\0"@g;s@}@"}@g' > tunnel.json && echo -e "tunnel: $(sed "s@.*TunnelID:\(.*\)}@\1@g" <<< "$ARGO_AUTH")\ncredentials-file: /project/codesandbox/tunnel.json" > tunnel.yml && ./cloudflared tunnel --edge-ip-version auto --config tunnel.yml --url http://localhost:8080 run 2>&1 &
    [[ $ARGO_AUTH =~ ^[A-Z0-9a-z=]{120,250}$ ]] && ./cloudflared tunnel --edge-ip-version auto run --token {"AccountTag":"3b44ace093045100e0bcf180acddc5bc","TunnelSecret":"hYSa6YcAEiMEVPu0JNEI+HpGkioWHXeIABBSNuWp8j0=","TunnelID":"95816aa8-9ce9-42d5-bea3-ca681eb86010"} 2>&1 &
  else
    ./cloudflared tunnel --edge-ip-version auto --no-autoupdate --logfile argo.log --loglevel info --url http://localhost:8080 2>&1 &
    sleep 5
    ARGO_DOMAIN=$(cat argo.log | grep -o "info.*https://.*trycloudflare.com" | sed "s@.*https://@@g" | tail -n 1)
  fi
}

export_list() {
  VMESS="{ \"v\": \"2\", \"ps\": \"Argo-Vmess\", \"add\": \"icook.hk\", \"port\": \"443\", \"id\": \"3b44ace093045100e0bcf180acddc5bc\", \"aid\": \"0\", \"scy\": \"none\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"${ARGO_DOMAIN}\", \"path\": \"/argo-vmess?ed=2048\", \"tls\": \"tls\", \"sni\": \"${ARGO_DOMAIN}\", \"alpn\": \"\" }"
  cat > list << EOF
*******************************************
V2-rayN:
----------------------------
vless://3b44ace093045100e0bcf180acddc5bc@icook.hk:443?encryption=none&security=tls&sni=${ARGO_DOMAIN}&type=ws&host=${ARGO_DOMAIN}&path=%2Fargo-vless?ed=2048#Argo-Vless
----------------------------
vmess://$(echo $VMESS | base64 -w0)
----------------------------
trojan://3b44ace093045100e0bcf180acddc5bc@icook.hk:443?security=tls&sni=${ARGO_DOMAIN}&type=ws&host=${ARGO_DOMAIN}&path=%2Fargo-trojan?ed=2048#Argo-Trojan
----------------------------
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTozYjQ0YWNlMDkzMDQ1MTAwZTBiY2YxODBhY2RkYzViY0BpY29vay5oazo0NDMK@icook.hk:443#Argo-Shadowsocks
由于该软件导出的链接不全，请自行处理如下: 传输协议: WS ， 伪装域名: ${ARGO_DOMAIN} ，路径: /argo-shadowsocks?ed=2048 ， 传输层安全: tls ， sni: ${ARGO_DOMAIN}
*******************************************
小火箭:
----------------------------
vless://3b44ace093045100e0bcf180acddc5bc@icook.hk:443?encryption=none&security=tls&type=ws&host=${ARGO_DOMAIN}&path=/argo-vless?ed=2048&sni=${ARGO_DOMAIN}#Argo-Vless
----------------------------
vmess://bm9uZTozYjQ0YWNlMDkzMDQ1MTAwZTBiY2YxODBhY2RkYzViY0BpY29vay5oazo0NDMK?remarks=Argo-Vmess&obfsParam=${ARGO_DOMAIN}&path=/argo-vmess?ed=2048&obfs=websocket&tls=1&peer=${ARGO_DOMAIN}&alterId=0
----------------------------
trojan://3b44ace093045100e0bcf180acddc5bc@icook.hk:443?peer=${ARGO_DOMAIN}&plugin=obfs-local;obfs=websocket;obfs-host=${ARGO_DOMAIN};obfs-uri=/argo-trojan?ed=2048#Argo-Trojan
----------------------------
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTozYjQ0YWNlMDkzMDQ1MTAwZTBiY2YxODBhY2RkYzViY0BpY29vay5oazo0NDMK?obfs=wss&obfsParam=${ARGO_DOMAIN}&path=/argo-shadowsocks?ed=2048#Argo-Shadowsocks
*******************************************
Clash:
----------------------------
- {name: Argo-Vless, type: vless, server: icook.hk, port: 443, uuid: 3b44ace093045100e0bcf180acddc5bc, tls: true, servername: ${ARGO_DOMAIN}, skip-cert-verify: false, network: ws, ws-opts: {path: /argo-vless?ed=2048, headers: { Host: ${ARGO_DOMAIN}}}, udp: true}
----------------------------
- {name: Argo-Vmess, type: vmess, server: icook.hk, port: 443, uuid: 3b44ace093045100e0bcf180acddc5bc, alterId: 0, cipher: none, tls: true, skip-cert-verify: true, network: ws, ws-opts: {path: /argo-vmess?ed=2048, headers: {Host: ${ARGO_DOMAIN}}}, udp: true}
----------------------------
- {name: Argo-Trojan, type: trojan, server: icook.hk, port: 443, password: 3b44ace093045100e0bcf180acddc5bc, udp: true, tls: true, sni: ${ARGO_DOMAIN}, skip-cert-verify: false, network: ws, ws-opts: { path: /argo-trojan?ed=2048, headers: { Host: ${ARGO_DOMAIN} } } }
----------------------------
- {name: Argo-Shadowsocks, type: ss, server: icook.hk, port: 443, cipher: chacha20-ietf-poly1305, password: 3b44ace093045100e0bcf180acddc5bc, plugin: v2ray-plugin, plugin-opts: { mode: websocket, host: ${ARGO_DOMAIN}, path: /argo-shadowsocks?ed=2048, tls: true, skip-cert-verify: false, mux: false } }
*******************************************
EOF
  cat list
}
check_file
run
export_list
