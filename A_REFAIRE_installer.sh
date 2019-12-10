#!/bin/bash
#


#
#         TODO A REVOIR
#





# tools-linux automated application installer 
#
# Simply run this command and you're ready to go
#   TODO : curl -sS http://gitlab.mgdis.fr/lebideau-e/tools-linux/...... | sh
#   
#   cd $HOME && apt-get update && apt-get install -y git\
#   && git clone https://github.com/roneMDB/tools-linux.git\
#   && cd tools-linux && ./installer.sh
#   
#

export NVM_VERSION=v0.33.11
export NVM_URL="https://github.com/creationix/nvm"
export RESTY_URL="http://github.com/micha/resty/raw/master/resty"
export SHELLTYPE="$(basename "/$SHELL")"
export DATE_UNIX="$(date '+%Y%m%d%H%M%S')"

get_date_unix () {
  echo $DATE_UNIX
}

bak_file () {
  if [ $# -eq 1 ]; then
    cp $1 $1.bak_$(get_date_unix)
  fi
}

get_detected_profile () {
  local DETECTED_PROFILE
  DETECTED_PROFILE=''

  if [ "$SHELLTYPE" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  fi
  echo $DETECTED_PROFILE

  unset DETECTED_PROFILE
}

initInstaller () {
  if [ $(id -u -n) == "root" ]; then
    which sudo > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      apt-get update
      apt-get install -y sudo
      if [ $? -ne 0 ]; then
        echo "${Cara_failed} ERROR : apt-get install -y sudo failed !"
        exit 1
      fi
      sudo apt-get update
    fi
  else
    echo "INFO : You are not root"
    which sudo > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "${Cara_failed} ERROR : you are need sudo !"
      exit 1
    fi
  fi
}

installAptGet () {
    if [ $# -eq 1 ]
    then
      local APPLICATION
      APPLICATION=$1
      which $APPLICATION > /dev/null 2>&1
      if [ $? -ne 0 ]
      then
         sudo apt-get install -y $APPLICATION
         if [ $? -ne 0 ]; then
          echo "${Cara_failed} ERROR : sudo apt-get install -y $APPLICATION failed !"
          exit 1
        fi
      else
        echo "=> $APPLICATION is already install"
      fi
    else
        echo "${Cara_failed} ERROR :bad parameters !"
        echo "USAGE :$0 \"<application>\""
    fi
    unset APPLICATION
}

installNpm () {
    if [ $# -eq 1 ]
    then
      local APPLICATION
      APPLICATION=$1
      which $APPLICATION > /dev/null 2>&1
      if [ $? -ne 0 ]
      then
        echo "Installation de $APPLICATION"
        npm i -g $APPLICATION
        if [ $? -ne 0 ]; then
          echo "${Cara_failed} ERROR :npm ci -g $APPLICATION failed !"
          exit 1
        fi
      else
        echo "=> $APPLICATION is already install"
      fi
    else
        echo "${Cara_failed} ERROR :bad parameters !"
        echo "USAGE :$0 \"<application>\""
    fi
    unset APPLICATION
}

load_apt_get () {
  if [ $# -eq 1 ]
  then
    local FILE_APPLICATION
    FILE_APPLICATION=$1
    while IFS='' read -r line || [[ -n "$line" ]]; do
        installAptGet $line
        #echo "Text read from file: $line"
    done < $FILE_APPLICATION
  else
    echo "${Cara_failed} ERROR :bad parameters !"
    echo "USAGE :$0 \"<file application>\""
  fi
  unset FILE_APPLICATION
}


load_npm () {
  if [ $# -eq 1 ]
  then
    local FILE_APPLICATION
    FILE_APPLICATION=$1
    while IFS='' read -r line || [[ -n "$line" ]]; do
        installNpm $line
        #echo "Text read from file: $line"
    done < $FILE_APPLICATION
  else
    echo "${Cara_failed} ERROR :bad parameters !"
    echo "USAGE :$0 \"<file application>\""
  fi
  unset FILE_APPLICATION
}

nvm_install_dir() {
  echo "${NVM_DIR:-"$HOME/.nvm"}"
}

nvm_latest_version() {
  echo "$NVM_VERSION"
}


#if [ ! -d ~/.nvm ]; then
#
#  curl https://raw.githubusercontent.com/creationix/nvm/v0.11.1/install.sh | bash
#  source ~/.nvm/nvm.sh
#  source ~/.profile
#  source ~/.bashrc
#  nvm install 5.0
#  npm ci
#  npm run front
#fi
install_nvm () {
  if [ ! -d $HOME/.nvm ]; then 
    echo
    echo "Install nvm version : $(nvm_latest_version)"
    echo "Are you ok ? (y/n)"
    echo "  $NVM_URL"
    read NVM_VERSION_OK
    if [ $NVM_VERSION_OK = "Y" ] || [ $NVM_VERSION_OK = "y" ]; then
      curl -o- https://raw.githubusercontent.com/creationix/nvm/$(nvm_latest_version)/install.sh | $SHELLTYPE
      source ~/.nvm/nvm.sh
      source $(get_detected_profile)
      nvm install --lts 
      nvm use --lts
    else
      echo "Choose an other version of nvm in this file $(basename $0)..."
      exit 1
    fi
  fi  
}

install_resty () {
  if [ -f $HOME/Applications/resty ]; then 
    echo "=> resty is already install"
  else
    mkdir -p $HOME/Applications/
    cd $HOME/Applications/
    command curl -L $RESTY_URL > resty
    . resty
    cd -
  fi
}

insert_alias () {
  local DETECTED_PROFILE
  # TODO A tester
  #DETECTED_PROFILE=$(get_detected_profile)
  DETECTED_PROFILE=''

  local FILE_LOAD
  FILE_LOAD=$PWD/load.sh

  if [ "$SHELLTYPE" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  fi

  # TODO tout déplacer dans load.sh
  local ADDBASHRC
  ADDBASHRC="\n# Add file load.sh\nif [ -f "$FILE_LOAD" ]; then\n. "$FILE_LOAD"\nfi\n\n"

  if [ -f $DETECTED_PROFILE ]; then
    # save detected profil
    bak_file $DETECTED_PROFILE

    ALREADY_DETECTED_PROFILE=$(grep -c "$FILE_LOAD" "$DETECTED_PROFILE")
    if [ $? -ne 0 ]; then
      echo "=> Appending source string to $DETECTED_PROFILE"
      command printf "$ADDBASHRC" >> "$DETECTED_PROFILE"
    else
      echo "=> Source string already in $DETECTED_PROFILE"
    fi    
  
  else
    echo "=> no detected profile find !"
  fi

  unset DETECTED_PROFILE
  unset ADDBASHRC
}

######### MAIN

initInstaller

# install ansbile en version 
echo "TODO install ansible ?" 
# sudo pip install 'ansible==2.1.1.0'

# install docker
echo "TODO install docker" 
# sudo apt install docker.io
# sudo systemctl start docker
# sudo systemctl enable docker
# docker --version

# install docker-compose
echo "TODO install docker" 
# DOCKER_COMPOSE_VERSION="1.21.2"
# sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
# docker-compose --version

# install mongodb local
echo "TODO install mongodb local ?"
#echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
#sudo apt-get install -y mongodb-org

# zsh-autoenv
echo "TODO zsh-autoenv :"
# git clone https://github.com/Tarrasch/zsh-autoenv ~/.dotfiles/lib/zsh-autoenv
# echo 'source ~/.dotfiles/lib/zsh-autoenv/autoenv.zsh' >> ~/.zshrc
echo "git clone https://github.com/Tarrasch/zsh-autoenv ~/.dotfiles/lib/zsh-autoenv"
echo "echo 'source ~/.dotfiles/lib/zsh-autoenv/autoenv.zsh' >> ~/.zshrc"

# apt-get install
# load_apt_get "./data/apt-get"

# install nvm
# install_nvm

# install resty
#install_resty

# npm ci
load_npm "./data/npm"

# install zsh
echo "TODO install zsh et oh-my-zsh"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# TODO STS
# TODO gitkraken : https://www.gitkraken.com/

# inser alias, alias_dev and load.sh
#insert_alias

#cd /opt
#git clone https://github.com/jarun/googler.git

echo
echo "==> Close and reopen your terminal to start using 'tools-linux' now..."

unset NVM_VERSION
unset NVM_URL
unset RESTY_URL
unset SHELLTYPE
unset DATE_UNIX
