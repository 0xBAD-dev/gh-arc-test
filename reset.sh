#!/usr/bin/env bash

set -e

git checkout .
git checkout main
git reset --hard origin/reset
git push origin main --force-with-lease
