#!/bin/bash

#set hostname
sudo hostnamectl set-hostname XMGneo15Tumbleweed

#remove bloat
sudo zypper remove -u discover6

#lock packes and patterns so that programs are only updated, not installed
sudo zypper addlock discover6
sudo zypper addlock -t pattern games
sudo zypper addlock -t pattern kde_pim

#Switch to current Snapshot
sudo zypper dup

sudo zypper install rkhunter
sudo rkhunter --update
sudo rkhunter --propupd
#c for check q for skip keypress
sudo rkhunter -c -sk

#add personal repo
sudo zypper addrepo https://download.opensuse.org/repositories/home:nomispaz/openSUSE_Tumbleweed/home:nomispaz.repo

#add nvidia repo
sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA

#add security and game tools
sudo zypper addrepo https://download.opensuse.org/repositories/games:tools/openSUSE_Tumbleweed/games:tools.repo
sudo zypper addrepo https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/security.repo

#add tuxedo
sudo zypper addrepo https://rpm.tuxedocomputers.com/opensuse/15.5/repo-tuxedo-computers.repo

sudo zypper refresh

#change only specified packages to packman
sudo zypper install --from packman_essentials ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs vlc

sudo zypper install git thunderbird clipgrab clamav keepassxc virt-manager patterns-server-kvm_tools patterns-server-kvm_server chromium flatpak calibre dkms screenfetch osc spec-cleaner testdisk screenfetch veracrypt neovim emacs fish alacritty discord gcc gcc-c++

sudo firewall-cmd --set-default-zone block
#virensignaturen aktualisieren
sudo freshclam

#opensuse doesn'T have obs-studio -- flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.obsproject.Studio

#install freeplan mindmapping tool from flathub
flatpak install flathub org.freeplane.App

#virtual machines
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

sudo systemctl enable dkms.service
sudo systemctl start dkms.service

#tuxedo-keyboard an tuxedo-control-center via tuxedo-repos
sudo zypper install tuxedo-control-center tuxedo-drivers

#copy thunderbird-profiles
cp -r ~/install/.thunderbird ~/

#nvidia now via repos (open-kernel-modules)
sudo zypper install nvidia-open-driver-G06-signed-kmp-default kernel-firmware-nvidia-gspx-G06 nvidia-video-G06 nvidia-gl-G06 nvidia-compute-G06

#try without prime-select for now
#sudo zypper install suse-prime bbswitch-kmp-default
#sudo prime-select nvidia

#nvidia
#zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#or directly from nvidia. Better since dkms works with self build zen-kernel
#sudo zypper install kernel-devel kernel-source make dkms acpid libglvnd libglvnd-devel and supports nvidia-powerd
echo 'blacklist nouveau' | sudo tee -a /etc/modprobe.d/nvidia.conf
#echo 'add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "' | sudo tee -a /etc/dracut.conf.d/nvidia.conf
#Download nvidia driver from https://www.nvidia.de/Download/index.aspx?lang=de
#safe "run" file in install directory
#chmod +x ~/install/NVIDIA-Linux-x86_64-515.76.run
#boot into cmd without nouveau by adding nomodeset 3 to grub entry during boot
#login with root
#then run NVIDIA Installer. dont blacklist (was already done above), no xconf, yes to dkms
#sudo sh NVIDIA-Linux-x86_64-515.76.run
sudo dracut -f
reboot

#enable nvidia-powerd: https://download.nvidia.com/XFree86/Linux-x86_64/510.73.05/README/dynamicboost.html
sudo cp /usr/share/doc/NVIDIA_GLX-1.0/nvidia-dbus.conf /etc/dbus-1/system.d
sudo systemctl enable nvidia-powerd.service
sudo systemctl start nvidia-powerd.service

#for automatic signing of dkms modules follow the instructions from /usr/share/doc/packages/dkms/README.md

############################################
#manual changes for KDE
- set adaptive-sync for external monitor to always under KDE to get maximum FPS on external monitor
- set inactivity and when laptop lid closed to "Do nothing" under power options. The system might not recover from sleep. TODO: check, where the problem is. Maybe swap-space?
