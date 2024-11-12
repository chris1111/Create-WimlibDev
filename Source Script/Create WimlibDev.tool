#!/bin/sh
# Create WimlibDev
# By chris1111
# Copyright (c) 2023, 2024 chris1111. All Right Reserved
# Credit: wimlib https://wimlib.net/ 
# Vars
indir="/Private/tmp"
dir="/Private/tmp/Wimlib-Imagex-Package"
sparseimage="/Private/tmp/WimlibDev.sparseimage"
WimlibDev="/$HOME/Desktop/WimlibDev.dmg"
if [[ $(mount | awk '$3 == "/Volumes/WimlibDev" {print $3}') != "" ]]; then
 hdiutil detach -force "/Volumes/WimlibDev"
fi
rm -rf $WimlibDev
rm -rf $sparseimage
rm -rf $dir
apptitle="Create WimlibDev"
version="1.0"
# Set Icon directory and file 
export ICNS=$(dirname "${0}")
iconfile="$ICNS/AppIcon.icns"
Sleep 1
response=$(osascript -e 'tell app "System Events" to display dialog "
Welcome WimlibDev
Disk image to using wimlib then create a windows USB install Media
Make sure you have Apple Command Line Tools or Xcode installed
You are about to Create WimlibDev.dmg
This will Install

/Volumes/WimlibDev/usr/include/wimlib.h
/Volumes/WimlibDev/usr/local/lib/libwim.15.dylib, libwim.a, libwim.la, pkgconfig
/Volumes/WimlibDev/usr/local/bin/wimlib-imagex
/Volumes/WimlibDev/usr/local/share/man/man1

Please make a choice\nCancel for Exit" buttons {"Cancel", "WimlibDev"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'"  ')


answer=$(echo $response | grep "WimlibDev")


# Cancel is user does not select WimlibDev
if [ ! "$answer" ] ; then
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  echo "Quitting application in 2 seconds"
  sleep 2
  echo "QUITAPP"
fi

osascript <<EOD
  tell application "Create WimlibDev"
      activate
  end tell
EOD

cd $indir
git clone https://github.com/chris1111/Wimlib-Imagex-Package.git
echo "WimlibDev"
Sleep 2
# Build if select WimlibDev
if [ "$action" == "WimlibDev" ] ; then
echo "Start Create-Windows-USB"
echo " "
fi
Sleep 1
hdiutil create -size 100m -type SPARSE -fs HFS+J -volname WimlibDev $sparseimage
Sleep 1
hdiutil attach -noverify -nobrowse $sparseimage
cd $dir
echo " "
echo "Prepare --> Install wimlib --> /Volumes/WimlibDev"
Sleep 1
mkdir -p /Volumes/WimlibDev/usr/local/bin
mkdir -p /Volumes/WimlibDev/usr/local/include
mkdir -p /Volumes/WimlibDev/usr/local/share
mkdir -p /Volumes/WimlibDev/usr/local/lib
Sleep 3
./configure --prefix=/Volumes/WimlibDev/usr/local CC=$CC --without-ntfs-3g --without-fuse --prefix=/Volumes/WimlibDev/usr/local
make
make install
echo "=============================================" 
echo "Your path --> /Volumes/WimlibDev/usr/local/bin ➤ wimlib-imagex" 
echo "=============================================" 
# Eject /Volumes/WimlibDev
hdiutil detach -force /Volumes/WimlibDev
Sleep 2
hdiutil convert $sparseimage -format UDZO -o $WimlibDev
Sleep 1
rm -rf $sparseimage
rm -rf $dir
echo "=============================================" 
echo "Done --> $WimlibDev" 
echo "=============================================" 
open -R $WimlibDev
