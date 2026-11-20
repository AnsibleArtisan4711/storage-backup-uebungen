#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
python3 raid_rechner.py 4 8000
echo; echo "## Mit 6 Platten zu 4000 GB und besserer URE-Rate"
python3 raid_rechner.py 6 4000 1e-15
