#!/usr/bin/env bash
set -euo pipefail
#
# Script Name: clone_notes.sh
# Description: Clone notes repo locally

# Work machines use a "github.com-personal" SSH host alias to distinguish keys
if [[ "${IS_WORK_MACHINE}" == "true" ]]; then
  git clone git@github.com-personal:jah377/zettelkasten.git ~/zettelkasten
else
  git clone git@github.com:jah377/zettelkasten.git ~/zettelkasten
fi

# Set local config for notes repo
git -C ~/zettelkasten config --local user.name "jah377"
git -C ~/zettelkasten config --local user.email "jonathan.harris.eit@gmail.com"

