# Create-WimlibDev
### Credit: [Wimlib](https://wimlib.net/), [chris1111](https://github.com/chris1111)
Download  Release ➢ [Create-WimlibDev](https://github.com/chris1111/Create-WimlibDev/releases/V1)
## Welcome WimlibDev
- Disk image to using wimlib then create a windows USB install Media
- Make sure you have Apple Command Line Tools or Xcode installed
- Disabled Gatekeeper

WimlibDev Disk Image is use on [Create-Windows-USB](https://github.com/chris1111/Create-Windows-USB) and its create from [Wimlib-Imagex-Package](https://github.com/chris1111/Wimlib-Imagex-Package)

![Screenshot](https://github.com/chris1111/Create-WimlibDev/assets/6248794/a89b5ade-adf1-4682-ba07-3e8d119eaff3)

Manuel Usage: ⇩
- Make sure `WimlibDev.dmg` and your `Win11_22H2_English_x64v1.iso` is on Desktop. 
- if your ISO has a different name, rename it at the end of the first command.
- Format your 8GB USB drive as MS-DOS (FAT) / Master Boot Record, then rename it to `WINUSB` to match the commands.

Terminal Command: ⇩

```bash
hdiutil mount -noverify -nobrowse -mountpoint /Volumes/WIN $HOME/Desktop/Win11_22H2_English_x64v1.iso
hdiutil attach $HOME/Desktop/WimlibDev.dmg
rsync -avh --progress --exclude=sources/install.wim /Volumes/WIN/ /Volumes/WINUSB
/Volumes/WimlibDev/usr/local/bin/wimlib-imagex split /Volumes/WIN/sources/install.wim /Volumes/WINUSB/sources/install.swm 3500
```
![Screenshot 2](https://github.com/chris1111/Create-WimlibDev/assets/6248794/565933aa-69cb-4a3b-ace0-24b4d234d078)
