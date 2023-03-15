#!/bin/bash

# Correct dimensions for banner
CORRECT_B_W=800
CORRECT_B_H=450

WORK_DIR=/tmp/devcade_publishing_script_temp
#ZIP_NAME=devcade-publishing-script-output # Oops actually it has to be the name of the game.

HOME_BASE_DIR=$(pwd)

set -e # Peace out if shit breaks

function help() {
	echo "Publish a dotnet game and output to a folder called 'publish' in the current directory."
	echo
	echo "-b : Set banner path | -i : Set icon path | -g : Set game path | -h : Print help"
}

function validate_images() {
	# Check banner/icon file type
	BANNER_TYPE=$(file -b --mime-type $BANNER)
	ICON_TYPE=$(file -b --mime-type $ICON)

	if [[ "$BANNER_TYPE" != "image/png" ]]; then
		echo Banner is $BANNER_TYPE
		echo "Error: Banner must be PNG!"
		exit 1
	fi

	if [[ "$ICON_TYPE" != "image/png" ]]; then
		echo Icon is $ICON_TYPE
		echo "Error: Icon must be PNG!"
		exit 1
	fi

	# Check width and height
	BANNER_WIDTH=$(file -b $BANNER | awk '{print $4}' | sed 's/,//g')
	BANNER_HEIGHT=$(file -b $BANNER | awk '{print $6}' | sed 's/,//g')

	ICON_WIDTH=$(file -b  $ICON | awk '{print $4}' | sed 's/,//g')
	ICON_HEIGHT=$(file -b $ICON | awk '{print $6}' | sed 's/,//g')

	if [[ "$BANNER_WIDTH" != "$CORRECT_B_W" || "$BANNER_HEIGHT" != "$CORRECT_B_H" ]]; then
		echo "Error: Banner dimensions must be $CORRECT_B_W x $CORRECT_B_H!"
		exit 1
	fi

	if [[ "$ICON_WIDTH" != "$ICON_HEIGHT" ]]; then
		echo "Error: Icon dimensions must be square!"
		exit 1
	fi
}

function build_game() {
	# Check that the game directory is actually a directory
	GAME_DIR_TYPE=$(file -b $GAME)
	if [[ $GAME_DIR_TYPE != "directory" ]]; then
		echo "Error: Game must be a Directory!"
		exit 1
	fi

	# Try building a dotnet app in that directory. The Dotnet SDK should do the rest for us.
	echo "Building Game. Please be paitent."
	cd $GAME
	dotnet publish -c Release -r linux-x64 --self-contained
	cd ..
	echo "Build complete."
}

function package_game() {
	# Create temporary directory
	rm -rf $WORK_DIR 
	mkdir -p $WORK_DIR 

	# Copy assets to temporary directory
	PUB="$GAME/bin/Release/net6.0/linux-x64/publish"

	cp -r $BANNER $ICON $PUB $WORK_DIR

	cd $WORK_DIR
	ZIP_NAME=$(basename $GAME)
	zip -r "$ZIP_NAME.zip" $BANNER $ICON "publish"
	cp "$ZIP_NAME.zip" $HOME_BASE_DIR

	# Delete temporary directory
	cd $HOME_BASE_DIR
	rm -rf $WORK_DIR 

	echo "Finished. Upload \""$ZIP_NAME.zip"\" to https://devcade.csh.rit.edu"
}

# === MAIN SCRIPT ===
# Get command line args
while getopts ":hb:i:g:" option; do
    case $option in
        b) # Set banner path
            BANNER=$OPTARG;;
        i) # Set icon path
            ICON=$OPTARG;;
        g) # Set game path
            GAME=$OPTARG;;
        h) # Print help
            help
            exit;;
    esac
done

# Check args
if [[ -z $BANNER || -z $ICON || -z $GAME ]]; then
	help
	exit 1
fi

# Banner/Icon validation
validate_images

# Build the game
build_game

# Package the game
package_game
