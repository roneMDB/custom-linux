# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias la='ls -lha'
alias ll='ls -alrth'
alias lt='ls -lrth'
alias p="pwd"
alias l='ls -lh'
# alias dir='ls -ahl | grep ^d'
alias ..='cd ..'
alias ....='cd ../..'

alias tools.cd='cd $REPOENV'


# Autres
alias h='history | tail -50'
# alias h.40='fc -il 1 | head -40'
alias ps.grep='ps aux | grep -v grep | grep '
alias ps.top10='ps aux | sort -rk 4,4 | head -n 10'


# search
alias du.here='du -hsc'
alias tools.search.backup='sudo find -regex "^.*~$"'
alias tools.search.backup.and.delete='sudo find -regex "^.*~$" -exec sudo rm -i {} \;'

#kill
alias tools.chrome.kill='kill -SIGSTOP $(pidof chrome)'

# TODO A revoir
# alias tools.explorer='nautilus'

# code
alias tools.code='code $REPOENV'

# Système (de server-pc)
#alias temp='sudo hddtemp /dev/sda* ; echo "————————–" ; sensors'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias copy="rsync -av --progress"

# system
alias system.version='cat /etc/lsb-release'
alias system.list.service='service --status-all'
alias system.list.program='dpkg -l'
alias system.ip.public='curl ifconfig.me'
alias system.ip.local='ifconfig eth0 | grep "inet adr:" | cut -d: -f2 | awk "{ print $1}"'
alias system.ps.cpu.max='ps -eo pmem,pcpu,pid,args | tail -n +2 | sort -rnk 2 | head'
alias system.maj='sudo apt-get -y update ; sudo apt-get -y upgrade ; sudo apt-get -y dist-upgrade'
alias system.list.partitions='sudo fdisk -l ; echo "————————–" ; sudo parted -l ; echo "————————–" ; df -aTh ; echo "————————–" ; free -m ; echo "————————–" ; ls -l /dev/disk/by-label/'
alias system.heure='watch -n1 "banner \$(date +"%H:%M:%S")"'
alias system.encodage.terminal='echo $LC_CTYPE'
alias system.apt-source='grep ^ /etc/apt/sources.list.d/*'
alias system.lightdm.change='sudo dpkg-reconfigure lightdm'
# alias system.reload.env.elb='. ~/tools-linux/load.sh' ==> fonction bash tools.sh
alias shell.reload='clear && exec $SHELL -l'
alias s.r='shell.reload'

# reboot / halt / poweroff
# alias power.reboot='sudo /sbin/reboot'
# alias power.poweroff='sudo /sbin/poweroff'
# alias power.halt='sudo /sbin/halt'
# alias power.shutdown='sudo /sbin/shutdown'

alias tools.git.cheat='gnome-open "https://training.github.com/kit/downloads/fr/github-git-cheat-sheet.pdf" 2>/dev/null &'
alias tools.edit.gitconfig='$EDITOR ~/.gitconfig'
alias tools.alias.list='cat $REPOENV/shell/alias.sh | grep -i "^alias" | cut -c7- | cut -d"=" -f1'
alias tools.meteo.auray='curl -4 http://wttr.in/Auray'
alias tools.meteo.vannes='curl -4 http://wttr.in/Vannes'
alias tools.meteo='meteo.vannes'

alias tools.dayofyear='date +%j'

alias tools.count.file='find */ | cut -d/ -f1 | uniq -c | sort -rn'

alias color.cara="grep \"export Cara_\" $REPOENV/shell/colors.sh | cut -c8-"

# youtube-dl
# youtube-dl.playlist <url to playlist>
alias youtube-dl.playlist='youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" '
# netstat
alias netstat.tools='sudo netstat -tulpn'

# X for X11
# -L 8448:localhost:8448 
# ssh erwan@$TOOLS_HOST -p $TOOLS_SERVER_PORT -X

# $TOOLS_SERVER_HOST
# alias ssh.ds218plus.tunelSSH='ssh -L 27018:localhost:27017 -L 61208:localhost:61208 -L 8181:localhost:8181 -L 8010:localhost:8010 -L 32400:localhost:32400 erwan@$TOOLS_SERVER_HOST -p $TOOLS_SERVER_PORT -X'
alias ssh.ds218plus='ssh erwan@$TOOLS_SERVER_HOST -p $TOOLS_SERVER_PORT'
