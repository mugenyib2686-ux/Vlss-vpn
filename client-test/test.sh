#!/usr/bin/env bash
# Test bout-en-bout : le serveur VLESS doit accepter un client.
# Prérequis : le serveur (server.py) tourne déjà.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "Test 1 : VLESS via TCP (port 10000)..."
code_tcp=$(curl -s -o /dev/null -w "%{http_code}" --max-time 20 \
  -x http://127.0.0.1:1081 https://github.com/ || echo "FAIL")
echo "  HTTP $code_tcp"
if [ "$code_tcp" != "200" ] && [ "$code_tcp" != "301" ]; then
  echo "ÉCHEC : le tunnel VLESS/TCP ne fonctionne pas." >&2
  exit 1
fi

echo "Test 2 : VLESS via WebSocket (port 10080)..."
code_ws=$(curl -s -o /dev/null -w "%{http_code}" --max-time 20 \
  -x http://127.0.0.1:1082 https://github.com/ || echo "FAIL")
echo "  HTTP $code_ws"
if [ "$code_ws" != "200" ] && [ "$code_ws" != "301" ]; then
  echo "ÉCHEC : le tunnel VLESS/WS ne fonctionne pas." >&2
  exit 1
fi

echo
echo "OK : le serveur accepte un client VLESS (TCP et WebSocket)."
