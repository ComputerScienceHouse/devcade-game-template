#!/bin/bash

# Publish a dotnet game and output to a folder called 'publish' in the current directory.
# This file should be run from the top level directory of your project (the same one you
# run dotnet build, run, publish, etc. commands from)

# Get name of directory this is running in. This will be the name of the ZIP
basename=${PWD##*/}
basename=${basename:-/}

# assign paths
if [ $# -ge 2 ]
then
  # if args are provided, assign them to banner and icon paths and check that they point to files
  banner_path=$1
  banner_path="${banner_path/\~/$HOME}" # expand ~ to $HOME
  echo $banner_path
  if [ -e $banner_path ]
  then
    echo "Banner found. Moving to root directory"
  else
    echo "Banner path does not exist. Exiting"
    exit 1
  fi
  icon_path=$2
  icon_path="${icon_path/\~/$HOME}" # expand ~ to $HOME
  if [ -e $icon_path ]
  then
    echo "Icon found. Moving to root directory"
  else
    echo "Icon path does not exist. Exiting"
    exit 1
  fi

  # banner and icon must be in root directory to prevent zip weirdness
  cp $banner_path ./
  cp $icon_path ./

  # unset variables for checks later
  unset banner_path
  unset icon_path

else
  echo -n "Paths not specified. Searching..."
fi

# Search for them in the root directory now that they've been moved there.
# If they haven't been specified, this will also search for them.
# This will also check to make sure that the banner and icon have the
# correct extensions.
files="banner icon"
exts="png jpg jpeg"

# check for both the banner and icon
for file in ${files}
do
  for ext in ${exts}
  do
    if [ -f "./$file.$ext" ]
    then
      # set variable
      if [ $file = "banner" ]
      then
        banner_path="./$file.$ext"
      else
        icon_path="./$file.$ext"
      fi
      break
    fi
  done
done

if [ -z ${banner_path+x} ]
then
  echo "Banner not found in root directory. Exiting"
  if [ $# -ge 2 ] # if the user specified a path and the file was found, then it wasn't the correct file extension. Let them know
  then
    echo "Maybe the specified banner was not the correct file type?\nCorrect file types are .png, .jpg, or .jpeg"
  fi

fi

if [ -z ${icon_path+x} ]
then
  echo "Icon not found in root directory. Exiting"
  if [ $# -ge 2 ] # as above.
  then
    echo "Maybe the specified icon was not the correct file type?\nCorrect file types are .png, .jpg, or .jpeg"
  fi
  exit 1
fi

# Complete earlier echo
if [ $# -lt 2 ]
then
  echo "found"
fi

# remove zip if it exists
rm $basename.zip

# Clean build directory
if [ -d ./bin ]
then
  rm -rf ./bin
fi

# actually build the game
echo -n "Building... "
dotnet publish -c Release -r linux-x64 --self-contained > /dev/null
echo "done"

# if publish folder already exists, remove it
if [ -d ./publish ]
then
  rm -r ./publish
fi

mv "./bin/Release/net6.0/linux-x64/publish" ./

echo -n "Zipping... "
zip -r $basename.zip ./publish $banner_path $icon_path 1>/dev/null && rm -r ./publish
echo "done"

