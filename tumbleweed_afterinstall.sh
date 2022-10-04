#!/bin/bash

#set hostname
sudo hostnamectl set-hostname VMTumbleweed

#third party repo
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials' packman_essentials

#add zsh repos
sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/openSUSE_Tumbleweed/shells:zsh-users:zsh-autosuggestions.repo
sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/openSUSE_Tumbleweed/shells:zsh-users:zsh-syntax-highlighting.repo
sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-history-substring-search/openSUSE_Tumbleweed/shells:zsh-users:zsh-history-substring-search.repo

sudo zypper refresh

sudo zypper dist-upgrade --from packman_essentials --allow-vendor-change

sudo zypper install --from packman_essentials ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs#sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials' packman_essentials


sudo zypper install vlc rkhunter thunderbird zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search calibre clipgrab clamav xlsclients keepassxc discord virt-manager make gcc dkms kernel-devel chromium

#enable wayland in different programs
mkdir -p ~/.config/environment.d/
echo "MOZ_ENABLE_WAYLAND=1" >> ~/.config/environment.d/envvars.conf

sudo firewall-cmd --set-default-zone block

#opensuse doesn'T have obs-studio -- flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.obsproject.Studio

#nvidia
#zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA


#zsh will be activated after restart or relogon
cp .zshrc ~/
#to be able to chsh
echo enter user password
chsh -s /bin/zsh
sudo chsh -s /bin/zsh
