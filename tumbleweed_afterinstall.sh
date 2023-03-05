#!/bin/bash

#Irgendwie war noch USB-Stick repo drin. die musste raus.
sudo zypper removerepo openSUSE-20220930-0

#set hostname
sudo hostnamectl set-hostname XMGp507Tumbleweed

#remove bloat
sudo zypper remove -u discover

#lock packes and patterns so that programs are only updated, not installed
sudo zypper addlock discover
sudo zypper addlock -t pattern games
sudo zypper addlock -t pattern kde_pim

#Switch to current Snapshot
sudo zypper dup

sudo zypper install rkhunter
sudo rkhunter --update
sudo rkhunter --propupd
#c for check q for skip keypress
sudo rkhunter -c -sk

#third party repo
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials' packman_essentials

#add personal repo
sudo zypper addrepo https://download.opensuse.org/repositories/home:nomispaz/openSUSE_Tumbleweed/home:nomispaz.repo

#add nvidia repo
sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA

#add security and game tools
sudo zypper addrepo https://download.opensuse.org/repositories/games:tools/openSUSE_Tumbleweed/games:tools.repo
sudo zypper addrepo https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/security.repo

#add tuxedo
sudo zypper addrepo https://rpm.tuxedocomputers.com/opensuse/15.4/repo-tuxedo-computers.repo

#add zsh repos
sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/openSUSE_Tumbleweed/shells:zsh-users:zsh-autosuggestions.repo
sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/openSUSE_Tumbleweed/shells:zsh-users:zsh-syntax-highlighting.repo
sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-history-substring-search/openSUSE_Tumbleweed/shells:zsh-users:zsh-history-substring-search.repo

sudo zypper refresh

#change all essentials to packman. includes mesa since vaapi is disabled --> do not perform
#sudo zypper dist-upgrade --from packman_essentials --allow-vendor-change

#change only specified packages to packman
sudo zypper install --from packman_essentials ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs vlc

#install from personal repo since discord is not updated regularly by suse
sudo zypper install --from home_nomispaz discord

sudo zypper install git thunderbird zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search clipgrab clamav xlsclients keepassxc virt-manager patterns-server-kvm_tools patterns-server-kvm_server chromium flatpak calibre dkms screenfetch osc spec-cleaner testdisk firelight screenfetch veracrypt

#enable wayland in different programs
mkdir -p ~/.config/environment.d/
echo "MOZ_ENABLE_WAYLAND=1" >> ~/.config/environment.d/envvars.conf

sudo firewall-cmd --set-default-zone block
#virensignaturen aktualisieren
sudo freshclam

#opensuse doesn'T have obs-studio -- flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.obsproject.Studio

#install freeplan mindmapping tool from flathub
flatpak install flathub org.freeplane.App

#zsh will be activated after restart or relogon
cp zshrc ~/.zshrc
#to be able to chsh
echo enter user password
chsh -s /bin/zsh
sudo chsh -s /bin/zsh

#virtual machines
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

sudo systemctl enable dkms.service
sudo systemctl start dkms.service

#https://github.com/tuxedocomputers/tuxedo-keyboard
#sudo zypper install make gcc kernel-devel
#git clone https://github.com/tuxedocomputers/tuxedo-keyboard.git ~/git_clones/tuxedo-keyboard
#cd ~/git_clones/tuxedo-keyboard
#git checkout release
#make clean
#sudo make dkmsinstall
#sudo modprobe tuxedo_keyboard

#tuxedo-keyboard an tuxedo-control-center via tuxedo-repos
sudo zypper install tuxedo-control-center tuxedo-keyboard

#copy thunderbird-profiles
cp -r ~/install/.thunderbird ~/

#add user simonheise to wheel-group
usermod -aG wheel simonheise

#allow users of wheel group to execute all commands
echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
#ask for root pw when sudoing
echo "Defaults targetpw # Ask for the password of the target user" | sudo tee -a /etc/sudoers

#nvidia now via repos
sudo zypper install x11-video-nvidiaG06 nvidia-glG06 suse-prime bbswitch-kmp-default

sudo prime-select nvidia

#nvidia
#zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#or directly from nvidia:
#sudo zypper install kernel-devel kernel-source gcc make dkms acpid libglvnd libglvnd-devel
#echo 'blacklist nouveau' | sudo tee -a /etc/modprobe.d/nvidia.conf
#echo 'add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "' | sudo tee -a /etc/dracut.conf.d/nvidia.conf
#Download nvidia driver from https://www.nvidia.de/Download/index.aspx?lang=de
#safe "run" file in install directory
#chmod +x ~/install/NVIDIA-Linux-x86_64-515.76.run
#boot into cmd without nouveau by adding nomodeset 3 to grub entry during boot
#login with root
#then run NVIDIA Installer. dont blacklist (was already done above), no xconf, yes to dkms
#sudo sh NVIDIA-Linux-x86_64-515.76.run
#sudo zypper install suse-prime
#next command only necessary if suse-prime didnt already updated initram with dracut.
#sudo dracut -f
#reboot
