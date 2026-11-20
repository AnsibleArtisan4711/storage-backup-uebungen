#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
python3 rotation.py
echo; echo "## ZFS-Modell"
python3 zfs_snapshots_modell.py
