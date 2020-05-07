# usbos - Install Ubuntu 20.04 on USB drive

## Requirements

  * 2 usb drives
    * 1 of the drives to be used to flash the ubuntu installer ISO to.  Do that.
	* The other drive will be the drive you want to install on.


## Start

Boot from the ubuntu installer usb.  'Try Ubuntu' once you get there.

Connect the PC to the internet.  If via ethernet cable, this will be automatic -- this is a reminder for the wireless people.

Open the Terminal.

Plug in the other usb.

```
dmesg | tail
```

Make note of the 'sdX' device that is reported here.  This is your target usb drive.

Enter a superuser terminal with:

```
sudo -i
````

Then run these commands to install some req'd utilities:

```
apt update
apt install -y git
```

Then download this repo:

```
git clone https://github.com/staehle/usbos.git
```

Then cd into there and source our var file, which will give us a safe-bash function to do so. Give that 1 argument of our target usb device (replace `sdX` with what you noted earlier):

```
cd usbos
source set-dev.sh
set-inst-dev /dev/sdb
```

This will print out the device info so you can confirm you didn't fat-finger the name.

Now, run `setup-parts.sh` normally.  You can edit the head of this file to stop certain actions from happening (Useful if you are debugging an existing drive created by this):

```bash
# Steps:
new_parts=1
new_luks=1
new_fs=1
add_swap=1
```

Run:

```
./setup-parts.sh
```



