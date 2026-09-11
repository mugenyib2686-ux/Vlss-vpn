#!/usr/bin/env python3
"""Vlss-vpn : serveur VLESS (Xray-core).

Démarrage :
    python3 server.py

La config du serveur est lue dans config.json (même répertoire).
"""
import json
import os
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(BASE, "runtime"))

try:
    import xray  # noqa: E402
except ImportError:
    sys.stderr.write(
        "Erreur : le binaire Xray n'est pas installé dans runtime/.\n"
        "Lancez d'abord : bash setup.sh\n"
    )
    sys.exit(1)

CONFIG_PATH = os.path.join(BASE, "config.json")


def main() -> None:
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        config = f.read()
    # Valide que c'est bien du JSON avant de le passer au core.
    json.loads(config)

    print("Serveur VLESS (Xray-core) en cours de démarrage...", flush=True)
    print(f"  - VLESS/TCP sur le port 10000", flush=True)
    print(f"  - VLESS/WS  sur le port 10080 (chemin /vless-ws)", flush=True)

    # startFromJSON démarre le core Xray et bloque tant que le serveur tourne.
    xray.startFromJSON(config)


if __name__ == "__main__":
    main()
