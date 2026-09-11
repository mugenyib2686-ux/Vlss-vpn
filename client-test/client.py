#!/usr/bin/env python3
"""Client VLESS de test : démarre un core Xray client local.

Le trafic entrant sur :
  - http://127.0.0.1:1081 -> sort via VLESS/TCP (port 10000 du serveur)
  - http://127.0.0.1:1082 -> sort via VLESS/WS  (port 10080 du serveur)

Utile pour vérifier que le serveur accepte bien un client VLESS.
"""
import json
import os
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(BASE)
sys.path.insert(0, os.path.join(ROOT, "runtime"))

import xray  # noqa: E402

CONFIG = os.path.join(BASE, "client-config.json")


def main() -> None:
    with open(CONFIG, "r", encoding="utf-8") as f:
        config = f.read()
    json.loads(config)
    print("Client VLESS de test démarré (proxies HTTP sur 127.0.0.1:1081 et :1082)", flush=True)
    xray.startFromJSON(config)


if __name__ == "__main__":
    main()
