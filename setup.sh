#!/usr/bin/env bash
# Installe le binaire Xray-core dans runtime/ (à partir de PyPI).
#
# Source : paquet "Xray-core" sur PyPI (https://pypi.org/project/Xray-core/),
# qui embarque le core Xray (upstream XTLS/Xray-core) compilé pour la
# plateforme courante. Aucune installation de Go requise.
set -euo pipefail
cd "$(dirname "$0")"

PYVER=$(python3 -c "import sys; print(f'cp{sys.version_info[0]}{sys.version_info[1]}')")
echo "Python détecté : $PYVER"

URL=$(curl -sS --max-time 30 "https://pypi.org/pypi/xray-core/json" | python3 -c "
import json, sys
d = json.load(sys.stdin)
needle = '-${PYVER}-'
for r in d['urls']:
    n = r['filename']
    if needle in n and 'manylinux2014_x86_64' in n:
        print(r['url'])
        break
" )

if [ -z "$URL" ]; then
  echo "Erreur : aucun wheel compatible trouvé sur PyPI." >&2
  exit 1
fi

echo "Téléchargement : $URL"
TMP=$(mktemp /tmp/xray-core-XXXX.whl)
curl -sSL --max-time 300 -o "$TMP" "$URL"

rm -rf runtime
mkdir -p runtime
python3 -m zipfile -e "$TMP" runtime/
rm -f "$TMP"

python3 -c "
import sys, os
sys.path.insert(0, 'runtime')
import xray
assert hasattr(xray, 'startFromJSON'), 'API xray incomplète'
print('OK : binaire Xray installé dans runtime/')
"
