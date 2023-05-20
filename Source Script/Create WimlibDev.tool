#!/bin/sh
# Create WimlibDev
# By chris1111
# Copyright (c) 2023, chris1111. All Right Reserved
# Credit: wimlib https://wimlib.net/ 
# Vars
indir="/Private/tmp"
dir="/Private/tmp/Wimlib-Imagex-Package"
librarywimlib="/Private/tmp/Wimlib-Imagex-Package/Library-wimlib.dmg"
sparseimage="/Private/tmp/WimlibDev.sparseimage"
WimlibDev="/$HOME/Desktop/WimlibDev.dmg"
if [[ $(mount | awk '$3 == "/Volumes/WimlibDev" {print $3}') != "" ]]; then
 hdiutil detach -force "/Volumes/WimlibDev"
fi
if [[ $(mount | awk '$3 == "/Volumes/Library-wimlib" {print $3}') != "" ]]; then
 hdiutil detach -force "/Volumes/Library-wimlib"
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

/Volumes/WimlibDev/usr/local/etc/libxml2, openssl@3
/Volumes/WimlibDev/usr/local/Cellar/wimlib, libxml2, openssl@3
/Volumes/WimlibDev/usr/local/bin/wimlib-imagex

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
mkdir -p /Volumes/WimlibDev/usr/local/opt
mkdir -p /Volumes/WimlibDev/usr/local/etc
hdiutil attach -noverify -nobrowse $librarywimlib
echo "Attach Image"
cp -Rp /Volumes/Library-wimlib/wimlib/usr/* /Volumes/WimlibDev/usr/
Sleep 3
export LIBXML2_CFLAGS="-L/Volumes/WimlibDev/usr/local/Cellar/libxml2/2.10.3_1/lib"
export LIBXML2_LIBS="/Volumes/WimlibDev//usr/local/Cellar/libxml2/2.10.3_1/include" 
export OPENSSL_CFLAGS="-L/Volumes/WimlibDev/usr/local/Cellar/openssl@3/3.0.7/lib"
export OPENSSL_LIBS="/Volumes/WimlibDev/usr/local/Cellar/openssl@3/3.0.7/include"
export PKG_CONFIG_PATH=/Volumes/WimlibDev/usr/local/Cellar/wimlib/1.14.1/lib
./configure --prefix=/Volumes/WimlibDev/usr/local CC=$CC --without-ntfs-3g --without-fuse --prefix=/Volumes/WimlibDev/usr/local/Cellar/wimlib/1.14.1
make
make install
ln -s /Volumes/WimlibDev/usr/local/Cellar/wimlib/1.14.1 /Volumes/WimlibDev/usr/local/opt/wimlib
ln -s /Volumes/WimlibDev/usr/local/Cellar/wimlib/1.14.1/include/wimlib.h /Volumes/WimlibDev/usr/local/include
ln -s /Volumes/WimlibDev/usr/local/Cellar/libxml2/2.10.3_1 /Volumes/WimlibDev/usr/local/opt/libxml2
ln -s /Volumes/WimlibDev/usr/local/Cellar/openssl@3/3.0.7 /Volumes/WimlibDev/usr/local/opt/openssl@3
ln -s /Volumes/WimlibDev/usr/local/Cellar/openssl@3/3.0.7 /Volumes/WimlibDev/usr/local/opt/openssl
ln -s /Volumes/WimlibDev/usr/local/Cellar/wimlib/1.14.1/bin/* /Volumes/WimlibDev/usr/local/bin
ls -v /Volumes/WimlibDev/usr/local/bin
cp -Rp /Volumes/WimlibDev/usr/local/Cellar/wimlib/1.14.1/share/man /Volumes/WimlibDev/usr/local/share/
echo $PKG_CONFIG_PATH
# Eject /Volumes/Library-wimlib
hdiutil detach -force /Volumes/Library-wimlib
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
