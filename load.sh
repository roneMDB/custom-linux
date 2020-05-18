# Récupération du répertoire du script
REPOENV="$( cd "$(dirname "$0")" ; pwd -P )"

# load conf -- TODO ajouter exemple de conf dans README
if [ -f $REPOENV/.conf ]; then
  zsh $REPOENV/.conf
fi

if [ -f ${REPOENV}/shell/colors.sh ]; then
  zsh $REPOENV/shell/colors.sh
fi

if [ -f ${REPOENV}/shell/alias.sh ]; then
  zsh $REPOENV/shell/alias.sh
fi

if [ -f $REPOENV/shell/tools.sh ]; then
  zsh $REPOENV/shell/tools.sh
fi

echo "custom-linux load !"