# ! TODO 
#use tools (this command)
# TODO A REVOIR CAR CUSTOM-LINUX et non TOOLS-CODE
# tools () {
#     PATHTOOLS="$REPOENV/shell/tools.sh"
#     HELPTOOLS=$(grep ^#use $PATHTOOLS | cut -c6-)
#     printf "${IYellow}$HELPTOOLS${Color_Off}\n"
#     unset PATHTOOLS
#     unset HELPTOOLS
# }

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

#use presse_papier <chaîne à copier>
# Utiliser "command | xclip -selection clipboard"
presse_papier () {
  echo "Utiliser 'command | xclip -selection clipboard'"
    # if [ $# -eq 1 ]
    # then
    #     xsel -cb
    #     echo -n "$1" | xsel -ib
    #     printf "${IGreen}Copied to clipboard ${Cara_check}${Color_Off}\n"
    #     printf "${IYellow}$(xsel --clipboard)${Color_Off}\n"
    # else
    #     printf "${Cara_failed} ERROR \t:\tbad parameters !\n"
    #     echo "USAGE \t:\t$0 \"<string>\""
    #     echo "EXEMPLE :\t$0 \"My string to clipboard\""
    # fi
}

#use repeat_cmd "<sleep in second>" "<command>"
#possible d'utiliser watch aussi (exemple : watch -n 2 ls -l)
repeat_cmd () {
    if [ $# -eq 2 ]
    then
        printf "${Red} ${Cara_gimel} Il est aussi possible d'utiliser watch (exemple : watch -n 2 ls -l)\n${Color_Off}"
        REPEAT_COMMAND='printf "${BCyan}\n${Cara_puce} time (every $1 sec.) ${Cara_fleche} "; eval echo "$(date +'%H:%M:%S:%N' | cut -b1-13)"; printf "${Cara_puce} cmd ${Cara_fleche} $2${Color_Off}"; echo "\n"; eval $2 ; sleep $1;'
        while (( 1 == 1 )) do 
          eval $REPEAT_COMMAND 
        done
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

#use color_list
color_list () {
  grep "export " $REPOENV/shell/colors.sh | cut -c8- | grep -v "Cara_" | cut -d'=' -f1 | while read -r line ; do
    local LINE_COLOR="printf \"\${$line}$line\${Color_Off}\""
    eval $LINE_COLOR
    echo
    unset LINE_COLOR
  done
}

# usage youtube_dl_playlist "Playlist pour Repas" "https://www.youtube.com/playlist?list=PL61mcSGXKTQozh7uy0v58bv1bOS2st4I7"
# Favoriser l'instalation de youtube-dl via pip plutot que apt-get"
# youtube_dl_playlist () {
#     if [ $# -eq 2 ]
#     then
#         TITRE_PLAYLIST=$1
#         echo $TITRE_PLAYLIST
#         mkdir $TITRE_PLAYLIST
#         if [ $? -ne 0 ]; then
#           printf "${Cara_failed} ERROR \t:\tyoutube_dl_playlist failed !\n"
#           echo "ERROR  youtube_dl_playlist failed "
#           exit 1
#         fi
#         cd $TITRE_PLAYLIST
#         youtube-dl -i --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$2"
#         cd ..
#         #echo "nohup youtube-dl -i --extract-audio --audio-format mp3 -o $2" 
#         #echo "$2" > test.txt
#     fi
# }

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

