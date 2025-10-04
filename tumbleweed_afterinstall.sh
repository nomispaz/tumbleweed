#!/bin/bash
	
#set hostname
sudo hostnamectl set-hostname XMGneo15

# TODO
# remove nomodeset from kernel command line and recreate grub

#remove bloat
#sudo zypper remove -u discover6

#lock packes and patterns so that programs are only updated, not installed
#sudo zypper addlock discover6
#sudo zypper addlock -t pattern games
#sudo zypper addlock -t pattern kde_pim

#Switch to current Snapshot
sudo zypper dup

# install codecs
# add vclc repo
sudo zypper ar -cfp 90 -n VLC http://download.videolan.org/pub/vlc/SuSE/Tumbleweed/ vlc
# add local repo
sudo zypper addrepo -cfGp 90 'dir:/home/nomispaz/git_repos/tumbleweed/tumbleweed_localrepo/rpms/' nomispaz_local

sudo zypper install --allow-vendor-change vlc vlc-codecs
sudo zypper dup --from vlc --allow-vendor-change
sudo zypper install --allow-vendor-change ffmpeg
sudo zypper dup --from nomispaz_local --allow-vendor-change

# basic tools and apps
sudo zypper install alacritty fish cpupower htop fastfetch keepassxc meld blueman gparted seahorse file-roller libqt5-wayland

# security
sudo zypper install clamav

# virtualisation
sudo zypper install virt-manager qemu podman

# editors
sudo zypper install neovim emacs

# fonts
sudo zypper install dejavu-fonts fontawesome-fonts

# additional programs
sudo zypper install calibre thunderbird

#install windowmanager tools
sudo zypper install dunst brightnessctl wireplumber gammastep gammastep-indicator grim rofi slurp wl-clipboard pavucontrol NetworkManager-applet

# install sway
sudo zypper install sway swaybg python3-dbus_next python3-i3ipc

# brave browser
sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo zypper install brave-browser

# programming
sudo zypper install rustup golang gopls elixir elixir-doc erlang
rustup toolchain install stable

# osc as a cli for opensuse buildservice
sudo zypper install osc

# cosmic desktop
#sudo zypper addrepo --refresh https://download.opensuse.org/repositories/X11:COSMIC:Next/openSUSE_Factory/X11:COSMIC:Next.repo
#sudo zypper install patterns-cosmic-cosmic

# niri
sudo zypper install niri

# gaming
sudo zypper install steam mangohud wine

# install from personal repo
# add personal repo from buildservice
sudo zypper addrepo https://download.opensuse.org/repositories/home:nomispaz/openSUSE_Tumbleweed/home:nomispaz.repo

sudo zypper install veracrypt jdtls emacs-cape-git emacs-catppuccin-theme-git emacs-company-mode-git emacs-consult-git emacs-evil-git emacs-go-mode-git emacs-markdown-mode emacs-rust-mode-git emacs-spacemacs-theme-git emacs-yasnippet-git emacs-yasnippet-snippets-git elixir-ls codium nwg-panel

#add nvidia repo
sudo zypper install openSUSE-repos-Tumbleweed-NVIDIA

# nvidia now via repos (open-kernel-modules)
sudo zypper install --from NVIDIA:repo-non-free nvidia-open-driver-G06-signed-kmp-meta

# install various programs
# sudo zypper install clipgrab patterns-server-kvm_tools patterns-server-kvm_server spec-cleaner testdisk gcc gcc-c++
sudo zypper install clipgrab spec-cleaner testdisk gcc gcc-c++

#set firewallzone to block
sudo firewall-cmd --set-default-zone block

#virensignaturen aktualisieren
sudo freshclam

# bottles and heroic, flatseal, obs-studio
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.usebottles.bottles
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub com.obsproject.Studio

# sudo rkhunter --update
# sudo rkhunter --propupd
#c for check q for skip keypress
# sudo rkhunter -c -sk

#install freeplan mindmapping tool from flathub --> I don't use this program currently
#flatpak install flathub org.freeplane.App

#copy thunderbird-profiles
# cp -r ~/install/.thunderbird ~/

#nvidia old way around 2023
#echo 'blacklist nouveau' | sudo tee -a /etc/modprobe.d/nvidia.conf

#finish
#sudo dracut -f
#reboot

#enable nvidia-powerd: https://download.nvidia.com/XFree86/Linux-x86_64/510.73.05/README/dynamicboost.html
#sudo cp nvidia-dbus.conf /etc/dbus-1/system.d
#sudo systemctl enable nvidia-powerd.service
#sudo systemctl start nvidia-powerd.service

#for automatic signing of dkms modules follow the instructions from /usr/share/doc/packages/dkms/README.md

############################################
#manual changes for KDE
# - set adaptive-sync for external monitor to always under KDE to get maximum FPS on external monitor
# - set inactivity and when laptop lid closed to "Do nothing" under power options. The system might not recover from sleep. TODO: check, where the problem is. Maybe swap-space?
