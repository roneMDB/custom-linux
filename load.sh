
# load conf -- TODO ajouter exemple de conf dans README
if [ -f /home/elb/tools-linux/.conf ]; then
  . /home/elb/tools-linux/.conf
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