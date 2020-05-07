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

If you run into an error similar to `Error: Partitions(s) on /dev/sdX have been written, but we have been unable to inform the kernel of the change`, then use the GNOME Disks utility to unmount (or lock LUKS) on every partition in that drive.  Then try the script again.

After this is complete, run the Ubuntu Installer.

Once you get to the 'Installation Type' section, select 'Something else'.

Use these settings:

 * Select the root file-system device for formatting (/dev/mapper/ubuntu--vg-root), press the Change button, choose Use As Ext4... and Mount point "/". Also select 'format'.
 * Select the swap device (/dev/mapper/ubuntu--vg-swap_1), press the Change button, choose Use as swap area
 * Select the boot file-system device for formatting (/dev/sdb2), press the Change button. choose Use as Ext4... and Mount point "/boot". Also select 'format'.
 * Select the boot-loader device. Boot-loader device should always be a raw disk not a partition or device-mapper node (e.g. "/dev/sdb", not "/dev/sdb2")

Click 'Install Now' to continue.


