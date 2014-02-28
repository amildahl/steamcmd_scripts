#!/bin/bash
#title           :generate_install_all_steamcmd_script.sh
#description     :This script generates a script for steamcmd that will install all (or most) of your games
#author		 :Andrew Dahl <Andrew@DrewDahl.com>
#date            :2014-02-27
#version         :1.0
#usage		 :generate_install_all_steamcmd_script.sh <Steam Profile Id>
#notes           :Script needs bash (obviously), so... Linux or Cygwin.  You pick!
#bash_version    :4.1.2(1)-release

OUTFILE="steam_script.cmd"

if [ "$#" -ne 1 ]; then
  echo -e "Illegal number of parameters

Usage: $0 <Steam Profile Id>"
  exit 1
fi
echo -e "
What does this generation script do?
Simple.  You give it your steam profile username and it goes here:
http://steamcommunity.com/id/<steam_profile_username>
And then it extracts your steam_id number and grabs the app_id numbers from here:
http://steamdb.info/calculator/?player=<steam_id>
And generates the script from there.  Additional app_id numbers can be found here:
http://steamdb.info/

READ THIS:
This script is used to generate a script to be run by steamcmd.exe
This scrpit requires bash to run (so Linux or Cygwin or something)
You can download steamcmd.exe from here: http://media.steampowered.com/installer/steamcmd.zip
Place steamcmd.exe in your C:\Program Files\Steam\ folder or wherever your steam install is located
The script that's generated assumes all games will be installed on the drive steam is installed on
For best results, do not use Steam while the generated script is running

How to run the generated script:
Copy the generated script to your steam installation directory
Open a cmd.exe and type the following:
cd \"C:\Program Files\Steam\" (or wherever your steam install is located)
steamcmd.exe
login <your steam username> <your steam password>
runscript $OUTFILE

Sit back and relax.\n"

PROFILE_ID=$( curl -s "http://steamcommunity.com/id/$1" | grep -o -E "steamid\":\"[0-9]+\"" | grep -o -E "[0-9]+" )
APP_IDS=$( curl -s "http://steamdb.info/calculator/?player=$PROFILE_ID" | grep -o -E "data-appid=\"[0-9]+\"" | grep -o -E "[0-9]+" | sed "s/ /\n/g" | sed "s/$/ validate/g" | sed "s/^/app_update /g" )
echo -e "@ShutdownOnFailedCommand 0\n@NoPromptForPassword 1\n$APP_IDS\nexit" > "$OUTFILE"

echo -e "Wrote script to $OUTFILE"
