# RasPad Launcher

- [RasPad Launcher](#raspad-launcher)
  - [Introduction](#introduction)
    - [Why we abandon RasPad OS and launch RasPad Launcher](#why-we-abandon-raspad-os-and-launch-raspad-launcher)
  - [Installation Guide](#installation-guide)
    - [Method 1: Quick install with a script](#method-1-quick-install-with-a-script)
    - [Method 2: Manually install](#method-2-manually-install)
      - [Qt runtime](#qt-runtime)
      - [Download RasPad Launcher package](#download-raspad-launcher-package)
      - [Install RasPad Launcher](#install-raspad-launcher)
      - [Other Options](#other-options)
        - [Matchbox keyboard](#matchbox-keyboard)
        - [Display Auto rotator](#display-auto-rotator)
  - [Uninstallation Guide](#uninstallation-guide)
    - [Quick uninstall script](#quick-uninstall-script)

## Introduction

RasPad Launcher is an open source software, simulating a launcher menu, focus on improving touch experience with RasPad, or other touchscreen.

### Why we abandon RasPad OS and launch RasPad Launcher

RasPad OS intergrated with RasPad Launcher, RasPad FAQ with our custom UI and boot animations, which is redundant. And people loves the idea of RasPad Launcher, so we decided to remove all unnecessary components, and keep RasPad Launcher as a single app. So people can install it your own Raspberry Pi OS.

## Installation Guide

### Method 1: Quick install with a script

If you don't really know what's going on, and don't care about messing up your own settings, like a brand new Raspbian. Or you are lazy enought to manual install everything, you can use the quick install script. The script will install these things:

- Qt runtime
- RasPad launcher with desktop profile
- RasPad FAQ desktop profile (Just a quick icon to browser RasPad FAQ webpage)
- display auto rotate for Accl SHIM

Download RasPad Launcher package, and extract it.

```bash
tar xzvf raspad-launcher-v1.0.0.tar.gz
```

Run install script

```bash
cd raspad-launcher
chmod +x install
sudo ./install
```

### Method 2: Manually install

With manually install, you can choose what you need to install, where you want it to be and more

#### Qt runtime

You will need qt runtime for RasPad Launcher

```bash
wget https://sunfounder.s3.us-east-1.amazonaws.com/others/qt5pi.zip
uzip qt5pi.zip
sudo cp qt5pi /usr/local/qt5pi
```

#### Download RasPad Launcher package

Download RasPad Launcher package, and extract it.

```bash
tar xzvf raspad-launcher-v1.0.0.tar.gz
cd raspad-launcher
```

#### Install RasPad Launcher

Copy the pre compiled Qt runtime. It MUST be in `/usr/local/qt5pi`, or else the bin won't be able to find it.

```bash
wget https://sunfounder.s3.us-east-1.amazonaws.com/others/qt5pi.zip
uzip qt5pi.zip
sudo cp ./qt5pi /usr/local/qt5pi
```

> You don't need this if you are just upgrading.

Copy RasPad Launcher related files including binary file, desktop profile, icon, raspad-launcher-helper and raspad-faq desktop profile.

```bash
sudo cp ./applications/raspad-launcher.desktop /usr/share/applications/
sudo cp ./applications/raspad-faq.desktop /usr/share/applications/
sudo cp ./icons/raspad.png /usr/share/icons/
sudo chmod +x /usr/local/bin/raspad-launcher
sudo chmod +x /usr/local/bin/raspad-launcher-helper
```

> raspad-launcher-helper is a simple script to make raspad launcher work like a normal menu.

> raspad-faq is a simple desktop profile to open RasPad FAQ wabpage in Chromium browser.

#### Other Options

Here's something you might want to install.

##### Matchbox keyboard

A simple keyboard for touchscreen, not great, but good enought to use.

```bash
sudo apt install matchbox-keyboard
```

##### Display Auto rotator

The display auto rotator for Accl SHIM

```bash
git clone --depth=1 https://github.com/sunfounder/python-sh3001
cd python-sh3001
sudo python3 install.py
cd ..
```

## Uninstallation Guide

If somehow you don't want RasPad Launcher anymore, here's how you uninstall it.

### Quick uninstall script

If you install with the quick install script, youcan simply run the uninstall script to un install it.

```bash
cd raspad-launcher
chmod +x uninstall
sudo ./uninstall
```
