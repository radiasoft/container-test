#!/bin/bash
. ~/.bashrc
set -e
env
python=$(type -p python 2>/dev/null || type -p python3)
"$python" -c 'import json; assert float(json.load(open("/rsmanifest.json"))["version"]) > 20170101.'
cat /rsmanifest.json
