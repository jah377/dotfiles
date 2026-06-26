#!/usr/bin/env bash
set -euo pipefail
#
# Script Name: clone_notes.sh
# Description: Clone notes repo locally

git clone git@github.com-personal:jah377/zettelkasten.git ~/zettelkasten

# Set local config for notes repo
git -C ~/zettelkasten config --local user.name "jah377"
git -C ~/zettelkasten config --local user.email "jonathan.harris.eit@gmail.com"

