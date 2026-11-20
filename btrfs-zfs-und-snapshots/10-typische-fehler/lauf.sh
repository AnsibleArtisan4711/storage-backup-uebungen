#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
python3 diagnose.py beispiel_meldungen.txt
echo "Rückgabecode: $?"
