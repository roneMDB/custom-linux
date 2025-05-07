#!/bin/bash

# a tester 
# REPOENV=$(dirname "$(readlink -f "$0")")

# Récupération du répertoire du script
CUSTOM_LINUX_REPOENV="$( cd "$(dirname "$0")" || exit 1 ; pwd -P )"
export CUSTOM_LINUX_REPOENV

# load conf -- TODO ajouter exemple de conf dans README
if [ -f "$CUSTOM_LINUX_REPOENV/.conf" ]; then
# shellcheck source=src/util.sh
  . "${CUSTOM_LINUX_REPOENV}/.conf"
fi

if [ -f "${CUSTOM_LINUX_REPOENV}/shell/colors.sh" ]; then
# shellcheck source=src/util.sh
  . "${CUSTOM_LINUX_REPOENV}/shell/colors.sh"
fi

if [ -f "${CUSTOM_LINUX_REPOENV}/shell/alias.sh" ]; then
# shellcheck source=src/util.sh
  . "$CUSTOM_LINUX_REPOENV/shell/alias.sh"
fi

if [ -f $CUSTOM_LINUX_REPOENV/shell/tools.sh ]; then
  . $CUSTOM_LINUX_REPOENV/shell/tools.sh
fi

# Custom aliases and functions specific to this machine
if [ -f $CUSTOM_LINUX_REPOENV/shell/specific.sh ]; then
  . $CUSTOM_LINUX_REPOENV/shell/specific.sh
fi

# printf "${Green}custom-linux loaded ${Cara_check}${Color_Off}\n"
