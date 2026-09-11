# Vlss-vpn — Serveur VLESS (Xray-core)

Serveur **VLESS** (protocole de XTLS / Xray-core) qui accepte les connexions de
clients VLESS. Deux ports d'écoute :

| Transport   | Port  | Chemin     |
|-------------|-------|------------|
| VLESS / TCP | `10000` | —          |
| VLESS / WS  | `10080` | `/vless-ws` |

## Identifiants client

- **UUID** : `da46959f-1a35-40b2-a10c-decc2eb5ad5f`
- **Chiffrement** : `none` (normal pour VLESS)
- **Security** : `none` (pas de TLS dans cette config de base)

> ⚠️ **Important** : changez l'UUID dans `config.json` (et dans la config de
> votre client) si ce serveur est exposé publiquement. Vous pouvez générer un
> nouvel UUID avec : `python3 -c "import uuid; print(uuid.uuid4())"`

## Installation

```bash
bash setup.sh        # télécharge le binaire Xray dans runtime/ (via PyPI)
```

`setup.sh` récupère le wheel `Xray-core` sur PyPI (il embarque le core Xray
compilé pour votre plateforme) — aucune installation de Go/CMake requise.

## Démarrage du serveur

```bash
python3 server.py
```

## Vérification (test bout-en-bout)

Le dossier `client-test/` contient un **client VLESS de test** (un second core
Xray). Avec le serveur démarré :

```bash
bash client-test/test.sh
```

Ce test fait passer une vraie requête HTTPS à travers le tunnel VLESS (via TCP
et via WebSocket). Résultat attendu :

```
Test 1 : VLESS via TCP (port 10000)...
  HTTP 200
Test 2 : VLESS via WebSocket (port 10080)...
  HTTP 200
OK : le serveur accepte un client VLESS (TCP et WebSocket).
```

## Connecter son propre client

Remplacez `HOTE` par l'adresse IP/domaine publique du serveur.

### VLESS / TCP

```
vless://da46959f-1a35-40b2-a10c-decc2eb5ad5f@HOTE:10000?encryption=none&security=none&type=tcp#vlss-vpn
```

### VLESS / WebSocket

```
vless://da46959f-1a35-40b2-a10c-decc2eb5ad5f@HOTE:10080?encryption=none&security=none&type=ws&path=%2Fvless-ws#vlss-vpn-ws
```

Compatible avec v2rayN, v2rayTun, Hiddify, Shadowrocket, FoXray, etc. (il
suffit d'importer le lien `vless://`).

### Config JSON manuelle (v2rayN "Ajouter manuellement")

```json
{
  "protocol": "vless",
  "address": "HOTE",
  "port": 10000,
  "id": "da46959f-1a35-40b2-a10c-decc2eb5ad5f",
  "security": "none",
  "type": "tcp",
  "encryption": "none"
}
```

Pour WebSocket : `"port": 10080`, `"type": "ws"`, `"path": "/vless-ws"`.

## Ajouter plusieurs clients

Chaque client a son UUID dans la section `settings.clients` de `config.json` :

```json
"clients": [
  { "id": "da46959f-1a35-40b2-a10c-decc2eb5ad5f", "email": "client-1" },
  { "id": "<autre-uuid>",                          "email": "client-2" }
]
```

Puis redémarrez le serveur.

## Ajouter du TLS (recommandé pour un usage public)

Sur un serveur avec un domaine, générez un certificat (Let's Encrypt) et
ajoutez à `streamSettings` :

```json
"security": "tls",
"tlsSettings": {
  "certificates": [
    {
      "certificateFile": "/etc/letsencrypt/live/votre-domaine/cert.pem",
      "keyFile": "/etc/letsencrypt/live/votre-domaine/privkey.pem"
    }
  ]
}
```

et utilisez `security=tls` dans le lien `vless://` du client.

## Structure du projet

```
├── config.json              # Config du serveur VLESS (ports, clients/UUID)
├── server.py                # Lanceur du serveur (démmarre le core Xray)
├── setup.sh                 # Installe le binaire Xray dans runtime/
├── runtime/                 # Binaire Xray-core (généré, non versionné)
└── client-test/
    ├── client-config.json   # Config d'un client VLESS de test
    ├── client.py            # Lanceur du client de test
    └── test.sh              # Test bout-en-bout (trafic réel à travers le tunnel)
```

## Notes

- Core Xray embarqué : version synchro **upstream v26.9.9** (paquet PyPI
  `Xray-core`, release automatique de l'upstream XTLS/Xray-core).
- Le binaire `runtime/` n'est pas versionné (`.gitignore`) ; `bash setup.sh`
  le réinstalle à la demande.
- Remplace le vieux `server.js` de test Node.js (même port 10000).
