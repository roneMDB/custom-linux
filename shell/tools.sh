
#use extract
extract () {
    if [ -f $1 ]
    then
        case $1 in
            (*.7z) 7z x $1 ;;
            (*.lzma) unlzma $1 ;;
            (*.rar) unrar x $1 ;;
            (*.tar) tar xvf $1 ;;
            (*.tar.bz2) tar xvjf $1 ;;
            (*.bz2) bunzip2 $1 ;;
            (*.tar.gz) tar xvzf $1 ;;
            (*.gz) gunzip $1 ;;
            (*.tar.xz) tar Jxvf $1 ;;
            (*.xz) xz -d $1 ;;
            (*.tbz2) tar xvjf $1 ;;
            (*.tgz) tar xvzf $1 ;;
            (*.zip) unzip $1 ;;
            (*.Z) uncompress ;;
            (*) printf "${Red}${Cara_failed} Don't know how to extract '$1'...${Color_Off}\n" ;;
        esac
    else
        printf "${Red}${Cara_failed} Error: '$1' is not a valid file!${Color_Off}\n"
    fi
}

#use tools.backup
tools.backup () {
  SAVE_DIR=$REPOENV/save/$(date +%Y%m%d)
  printf "${Yellow}Faire l'export dans ${BYellow}'$HOME/travail'${Yellow} de :\n"
  printf " ${Cara_sharp} ${BIYellow}Kantu${Yellow} (kantu_backup.zip)\n"
  printf " ${Cara_sharp} ${BIYellow}Simplenote${Yellow} (notes.zip)\n"
  printf " ${Cara_sharp} ${BIYellow}QuiteRSS${Yellow} (quiterss_backup.opml)\n"
  printf "${BIGreen}TODO : ${Green}Penser à pusher les repo git (tools-linux, TNR, ...)\n"
  printf "${Yellow}puis appuyer sur une touche${Color_Off}"
  read LINE;  
  
  # création du répertoire
  mkdir -p $SAVE_DIR
  if [ $? -ne 0 ]; then
    printf "${Red}${Cara_failed} error tools.backup - create dir failed${Color_Off}\n"
    exit 1
  fi
  printf "${IGreen}${Cara_star} Create ${SAVE_DIR} ${Cara_check}${Color_Off}\n"

  PWDSAVE=$(echo $PWD)
  cd $HOME/travail
  if [ $? -eq 0 ]
  then
    # delete node_modules
    find $HOME/travail/interventions -name 'node_modules' -type d -prune -exec rm -rf '{}' +
    # zip interventions
    tar czf interventions.tar.gz interventions
    # save
    rsync -av $HOME/travail/interventions.tar.gz $SAVE_DIR/interventions.tar.gz
    # del zip file
    rm $HOME/travail/interventions.tar.gz
    cd $PWDSAVE
    unset PWDSAVE
  fi
  printf "${IGreen}${Cara_star} Backup interventions ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/.gitconfig $SAVE_DIR/gitconfig.save
  printf "${IGreen}${Cara_star} Backup .gitconfig ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/.zshrc $SAVE_DIR/zshrc.save
  printf "${IGreen}${Cara_star} Backup .zshrc ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/travail/kantu_backup.zip $SAVE_DIR/kantu_backup.zip
  printf "${IGreen}${Cara_star} Backup kantu_backup.zip ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/travail/quiterss_backup.opml $SAVE_DIR/quiterss_backup.opml
  printf "${IGreen}${Cara_star} Backup quiterss_backup.opml ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/travail/notes.zip $SAVE_DIR/notes.zip
  printf "${IGreen}${Cara_star} Backup notes.zip ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/.config/Code/User/settings.json $SAVE_DIR/vscode_settings.json
  printf "${IGreen}${Cara_star} Backup vscode settings ${Cara_check}${Color_Off}\n"
  rsync -av $HOME/travail/TNR/servicesFiles $SAVE_DIR/
  printf "${IGreen}${Cara_star} Backup servicesFiles ${Cara_check}${Color_Off}\n"
    
  PATH_DISTANT_FIDJI_ELB="//fidji/travail/lebideau-e"
  PATH_FIDJI_ELB="/media/fidji_lebideau-e"
  # si le répertoire n'existe pas
  if ! [ -d $PATH_FIDJI_ELB ];
  then 
    # pas trouvé mieux que le chmod 777 pour écrire
    sudo mkdir $PATH_FIDJI_ELB && sudo chmod 777 $PATH_FIDJI_ELB
    if [ $? -ne 0 ]; 
    then
      printf "${Cara_failed} ERROR \t:\create diretory $PATH_FIDJI_ELB failed !\n"
      exit 1
    fi
  fi
  sudo mount -t cifs -o username=lebideau-e,domain=OCEANIE $PATH_DISTANT_FIDJI_ELB $PATH_FIDJI_ELB
  rsync -av $PATH_FIDJI_ELB/Sauvegarde/Administration $SAVE_DIR/
  sudo umount $PATH_FIDJI_ELB
  unset PATH_DISTANT_FIDJI_ELB
  unset PATH_FIDJI_ELB

  # zip save directory
  zip -r ${SAVE_DIR}.zip $SAVE_DIR && rm -Rf $SAVE_DIR/

  # list save dir
  echo
  echo "${BCyan}Contenu du répertoire de sauvegarde :${Color_Off}"
  ls -1d $REPOENV/save/*
  echo "${Cyan}${Cara_tabul}cd $REPOENV${Color_Off}"

  unset SAVE_DIR
}

#use presse-papier <chaîne à copier>
presse-papier () {
    if [ $# -eq 1 ]
    then
        xsel -cb
        echo -n "$1" | xsel -ib
        printf "${IGreen}Copied to clipboard ${Cara_check}${Color_Off}\n"
        printf "${IYellow}$(xsel --clipboard)${Color_Off}\n"
    else
        printf "${Cara_failed} ERROR \t:\tbad parameters !\n"
        echo "USAGE \t:\t$0 \"<string>\""
        echo "EXEMPLE :\t$0 \"My string to clipboard\""
    fi
}

#use iban.to.clipboard
iban.to.clipboard () {
    $HOME/tools-linux/function/iban.sh
}

#use siret.to.clipboard
siret.to.clipboard () {
    $HOME/tools-linux/function/siret.sh
}

#use repeat.cmd "<sleep in second>" "<command>"
#possible d'utiliser watch aussi (exemple : watch -n 2 ls -l)
repeat.cmd () {
    if [ $# -eq 2 ]
    then
        printf "${Red} ${Cara_gimel} Il est aussi possible d'utiliser watch (exemple : watch -n 2 ls -l)\n${Color_Off}"
        REPEAT_COMMAND='printf "${BCyan}\n${Cara_puce} time (every $1 sec.) ${Cara_fleche} "; eval echo "$(date +'%H:%M:%S:%N' | cut -b1-13)"; printf "${Cara_puce} cmd ${Cara_fleche} $2${Color_Off}"; echo "\n"; eval $2 ; sleep $1;'
        while (( 1 == 1 )) { eval $REPEAT_COMMAND }
        
    else
        printf "${Cara_failed} ERROR \t:\tbad parameters !\n"
        echo "USAGE \t:\t$0 \"<second>\" \"<command>\""
        echo "EXEMPLE :\t$0 \"5\" \"ls\""
    fi
}

#use allo "<host>"
allo () {
    if [ $# -eq 1 ]
    then
        ALLO_HOST=$1
        printf "${IYellow}ping -w 1 -c 1 ${ALLO_HOST} ${Color_Off}\n"
        RESULTALLO=$(ping -w 1 -c 1 ${ALLO_HOST} 2>&1)
        if [ $? -ne 0 ]
        then
          echo "${IPurple}${RESULTALLO}${Color_Off}"
          echo
          printf "${IRed}${ALLO_HOST} n'est pas disponible !${Color_Off}\n"
        else
          echo
          echo "${IGreen}${ALLO_HOST} répond ${Cara_check}${Color_Off}\n"
        fi
        unset RESULTALLO
        unset ALLO_HOST
    else
        printf "${Cara_failed} ERROR \t:\tbad parameters !\n"
        echo "USAGE \t:\t$0 \"<host>\""
        echo "EXEMPLE :\t$0 \"google.com\""
    fi
}

wgetlistdir () {
  if [ $# -eq 1 ]
  then
    wget --user $TOOLS_PSB_NAME --password $TOOLS_PSB_PASSWORD  -d -r -np -N --spider -e robots=off --no-check-certificate "$1" 2>&1 | grep " -> " | grep -Ev "\/\?C=" | sed "s/.* -> //" | grep -E "^https" | grep -Ev "\/\.\.\/"
    if [ -d $SEEDBOX_HOST_NAME ]
    then
      rm -R $SEEDBOX_HOST_NAME
      if [ $? -ne 0 ]
      then
        echo "DELETE $SEEDBOX_HOST_NAME KO"
      fi
    fi
  else
    echo "ERROR : bad parameters"
    echo "USAGE : $0 <http link directory>"
  fi
}

#use color.list
color.list () {
  grep "export " $REPOENV/shell/colors.sh | cut -c8- | grep -v "Cara_" | cut -d'=' -f1 | while read -r line ; do
    local LINE_COLOR="printf \"\${$line}$line\${Color_Off}\""
    eval $LINE_COLOR
    echo
    unset LINE_COLOR
  done
}

git.count.author () {
  if [ -d ".git" ] 
  then
    if [ $# -eq 1 ]
    then
      git log --author="${1}" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
    else
      # printf "ERROR \t: bad parameters !\n"
      echo "USAGE \t:\t$0 <gitlab username>"
    fi
  else
    echo "USAGE \t:\tVous devez vous trouver dans un répertoire git"
  fi
}

git.count.line () {
  if [ -d ".git" ] 
  then
    for line in $(git shortlog -sn)
    do
      if [[ "$line" != [0-9]* ]] then
        echo "$line"
        git log --author="${line}" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
        echo
      fi
    done
  else
    echo "USAGE \t:\tVous devez vous trouver dans un répertoire git"
  fi
}

# usage youtube.dl.playlist "Playlist pour Repas" "https://www.youtube.com/playlist?list=PL61mcSGXKTQozh7uy0v58bv1bOS2st4I7"
# Favoriser l'instalation de youtube-dl via pip plutot que apt-get"
youtube.dl.playlist () {
    if [ $# -eq 2 ]
    then
        TITRE_PLAYLIST=$1
        echo $TITRE_PLAYLIST
        mkdir $TITRE_PLAYLIST
        if [ $? -ne 0 ]; then
          printf "${Cara_failed} ERROR \t:\tyoutube.dl.playlist failed !\n"
          echo "ERROR  youtube.dl.playlist failed "
          exit 1
        fi
        cd $TITRE_PLAYLIST
        youtube-dl -i --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$2"
        cd ..
        #echo "nohup youtube-dl -i --extract-audio --audio-format mp3 -o $2" 
        #echo "$2" > test.txt
    fi
}

#use bip
function bip() {
  echo -ne '\007'
}

# generate alias which open vscode with link in jump directory
for link in $MARKPATH/*(@)
do
  local MARKNAME="${link:t}"
  eval "alias ${MARKNAME}.code='jump ${MARKNAME} && code .'"
  unset MARKNAME
done

#  fonctiontest () {

#     if [ $# -eq 1 ]
#     then
#         echo "cd.repository && cd $1"
#         cd.repository && cd $1 && printf "${IGreen}cd $PWD ${Cara_check}${Color_Off}\n"
#     else
#         printf "${IRed}${Cara_failed} ERROR \t:\tbad parameters !${Color_Off}\n"
#     fi
#     echo "$@"
#     echo "$1"
#     echo "$#"

#     RESULT=$(ls -l)
#     RETOUR=$?
#     echo "RESULT = $RESULT"
#     echo "RETOUR = $RETOUR"
#  }

#use tools (this command)
tools () {
    PATHTOOLS="$REPOENV/shell/tools.sh"
    HELPTOOLS=$(grep ^#use $PATHTOOLS | cut -c6-)
    printf "${IYellow}$HELPTOOLS${Color_Off}\n"
    unset PATHTOOLS
    unset HELPTOOLS
}

if [ $(basename "/$SHELL") == "zsh" ]; then
    printf "${Blue}$(basename $0)  load!${Color_off}\n"
fi