# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-cs343
#!/usr/bin/env bash

# set up bash to handle errors more aggressively - a "strict mode" of sorts
set -e # give an error if any command finishes with a non-zero exit code
set -u # give an error if we reference unset variables
set -o pipefail # for a pipeline, if any of the commands fail with a non-zero exit code, fail the entire pipeline with that exit code

function status {
  Reset='   tput sgr0'       # Text Reset
  Red='     tput setaf 1'          # Red
  Green='   tput setaf 2'        # Green
  Blue='    tput setaf 4'         # Blue
  div="********************************************************************************"
  scriptname="$(basename "$0")"
  case "$1" in
    a)        echo "" && echo "$($Blue)<|${scriptname:0:1}$($Reset) [ ${2} ] ${div:$((${#2}+9))}" ;;
    b)        echo "$($Green)ok: [ ${2} ] ${div:$((${#2}+9))}$($Reset)" ;;
    s|status) echo "$($Blue)<|${scriptname:0:1}$($Reset) [ ${2} ] ${div:$((${#2}+9))}" ;;
    t|title)  echo "$($Blue)<|${scriptname}$($Reset) [ ${2} ] ${div:$((${#2}+8+${#scriptname}))}" ;;
    e|err)    echo "$($Red)fatal: [ ${2} ] ${div:$((${#2}+12))}$($Reset)" ;;
  esac
}

function safe_download {
  timestamp="`date '+%Y%m%d-%H%M%S'`"
  if [ ! -f "$1" ]; then
    status a "Download ${1}"
    curl -s -o $1 $2
    status b "Download ${1}"
  else
    status a "Update ${1}"
    mv $1 $1.$timestamp
    curl -s -o $1 $2
    if diff -q "$1" "$1.$timestamp" > /dev/null; then rm $1.$timestamp; fi
    status b "Update ${1}"
  fi
}

function safe_source {
  if [[ -z $(grep "$1" "$2") ]]; then echo "source $1" >> $2; fi
}

status t "Welcome to docker-cs343 bootstrap!"
status s "Andrew Paradi. https://github.com/andrewparadi/docker-cs343"

mainDir=cs343-work
srcDir=cs343-work/src

if [[ $HOME == /u* ]]; then
  #University of Waterloo server
  srcDir=cs343-os161
fi

while getopts "c" opt; do
    case "$opt" in
    # clean install
    c)  mkdir -p cs343-work/src
        cd cs343-work
        ;;
    esac
done

safe_download ./$srcDir/build-test.sh https://raw.githubusercontent.com/andrewparadi/docker-os161/master/build-test.sh
chmod +x ./$srcDir/build-test.sh

safe_download ./$srcDir/submit.sh https://raw.githubusercontent.com/andrewparadi/docker-os161/master/submit.sh
chmod +x ./$srcDir/submit.sh

if [[ "$HOME" != /u* ]]; then
  safe_download ./$mainDir/Makefile https://raw.githubusercontent.com/andrewparadi/docker-os161/master/Makefile

  # get the prebuilt Docker image
  docker pull andrewparadi/cs343-os161:latest
fi

status a "🍺  docker-cs343 bootstrap Fin."
