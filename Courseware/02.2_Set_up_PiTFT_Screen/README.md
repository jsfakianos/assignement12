# Set up PiTFT Screen


## Install the PiTFT

We are using Adafruit's 2.8" PiTFT display with capacitive touchscreen.

> **COMPATIBILITY:** as of the time of this writing (12/1/17), Adafruit's packages have not been updated for Raspbian Stretch; their GitHub repository has though, so we will use some code directly from there

```bash
cd ~
wget https://raw.githubusercontent.com/adafruit/Adafruit-PiTFT-Helper/ea39b5ed3feca2ffbbd1cdb2125f4a74d26d74d8/adafruit-pitft-helper2.sh
chmod +x adafruit-pitft-helper2.sh
sudo ./adafruit-pitft-helper2.sh
```

When prompted, select:

* ``3. PiTFT 2.8" capacitive touch (240x320)`` for the configuration
* ``2. 180 degrees (portait)`` for the rotation
* ``n`` for "Would you like the console to appear on the PiTFT display?"
* ``n`` for "Would you like the HDMI display to mirror to the PiTFT display?"

and select ``y`` to Reboot.

## Install `fbcp`

Kivy uses GLES, which will only be hardware accelerated on the primary framebuffer (/dev/fb0). The PiTFT uses /dev/fb1. As such, we'll use a tool called `fbcp` to blit the primary framebuffer to the PiTFT's framebuffer.

```
sudo apt-get install -y cmake
git clone https://github.com/tasanakorn/rpi-fbcp
cd rpi-fbcp/
mkdir build
cd build/
cmake ..
make
sudo install fbcp /usr/local/bin/fbcp
```

**NOTE:** the ``make`` might generate a Warning regarding "implicit declaration of function", but the target (``fbcp``) will be built.

Now that it's installed, we need to run fbcp on startup.

```bash
sudo bash -c 'echo -e "@reboot root /usr/local/bin/fbcp &\n" > /etc/cron.d/0_fbcp'
```

Now we'll chose a console font that reads better on the tiny screen. Run:

```bash
sudo dpkg-reconfigure console-setup
```

Select:

* **UTF-8**
* **Guess optimal character set**
* **Terminus** 
* **6x12 (framebuffer only)**.

Finally, add the following lines to the bottom of **/boot/config.txt** with sudo. This will configure the primary framebuffer / HDMI output to 320x240. **This will most likely break your HDMI output on TVs until you remove these lines.**

```
hdmi_force_hotplug=1
hdmi_cvt=240 320 60 1 0 0 0
hdmi_group=2
hdmi_mode=87
```

Save and quit. Run `sudo reboot`.

Next up: go to [Hello, Kivy](../02.3_Hello_Kivy/README.md)

&copy; 2015-18 LeanDog, Inc. and Nick Barendt
