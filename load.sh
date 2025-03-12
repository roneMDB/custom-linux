# Récupération du répertoire du script
REPOENV=$(dirname "$(readlink -f "$0")")

# load conf -- TODO ajouter exemple de conf dans README
if [ -f $REPOENV/.conf ]; then
  source $REPOENV/.conf
fi

if [ -f ${REPOENV}/shell/colors.sh ]; then
  . $REPOENV/shell/colors.sh
fi

if [ -f ${REPOENV}/shell/alias.sh ]; then
  . $REPOENV/shell/alias.sh
fi

if [ -f $REPOENV/shell/tools.sh ]; then
  . $REPOENV/shell/tools.sh
fi

# Custom aliases and functions specific to this machine
if [ -f $REPOENV/shell/specific.sh ]; then
  . $REPOENV/shell/specific.sh
fi

printf "${Green}custom-linux loaded ${Cara_check}${Color_Off}\n"