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

# install various programs
sudo zypper install git thunderbird clipgrab clamav keepassxc virt-manager patterns-server-kvm_tools patterns-server-kvm_server chromium flatpak calibre dkms screenfetch osc spec-cleaner testdisk screenfetch veracrypt neovim emacs fish alacritty discord gcc gcc-c++ mangohud htop steam mpv

#tuxedo-keyboard an tuxedo-control-center via tuxedo-repos
sudo zypper install tuxedo-control-center tuxedo-drivers

#nvidia now via repos (open-kernel-modules)
sudo zypper install nvidia-open-driver-G06-signed-kmp-default kernel-firmware-nvidia-gspx-G06 nvidia-video-G06 nvidia-gl-G06 nvidia-compute-G06 nvidia-compute-utils-G06

#set firewallzone to block
sudo firewall-cmd --set-default-zone block

#virensignaturen aktualisieren
sudo freshclam

#opensuse doesn't have obs-studio -- flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.obsproject.Studio

#install freeplan mindmapping tool from flathub --> I don't use this program currently
#flatpak install flathub org.freeplane.App

#add vlc-repo and install vlc-player
sudo zypper addrepo https://download.videolan.org/SuSE/Tumbleweed VLC
sudo zypper install vlc

#virtual machines
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

# activate dkms. currently not necessary since I don't use packages activated via dkms anymore
# sudo systemctl enable dkms.service
# sudo systemctl start dkms.service

#copy thunderbird-profiles
# cp -r ~/install/.thunderbird ~/

#nvidia
echo 'blacklist nouveau' | sudo tee -a /etc/modprobe.d/nvidia.conf

#finish
sudo dracut -f
reboot

#enable nvidia-powerd: https://download.nvidia.com/XFree86/Linux-x86_64/510.73.05/README/dynamicboost.html
sudo cp /usr/share/doc/NVIDIA_GLX-1.0/nvidia-dbus.conf /etc/dbus-1/system.d
sudo systemctl enable nvidia-powerd.service
sudo systemctl start nvidia-powerd.service

#for automatic signing of dkms modules follow the instructions from /usr/share/doc/packages/dkms/README.md

############################################
#manual changes for KDE
# - set adaptive-sync for external monitor to always under KDE to get maximum FPS on external monitor
# - set inactivity and when laptop lid closed to "Do nothing" under power options. The system might not recover from sleep. TODO: check, where the problem is. Maybe swap-space?
