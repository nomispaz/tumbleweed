#!/bin/bash

# ACTIVATE fedora non-free repos steam and nvidia prior to running this
# additionally, activate personal repo
sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:nomispaz:fedora/Fedora_42/home:nomispaz:fedora.repo

# activate rpmfusion
# remark: under https://admin.rpmfusion.org/pkgdb/packages/ a list of packages and the corresponding maintainer can be found.
# under https://src.fedoraproject.org/users a list of fedora maintainers can be found
# --> crosscheck if a maintainer in rpmfusion is a fedora maintainer. If yes, the package should be as secure as if it would have been in the official repository
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager setopt rpmfusion-free.enabled=1
sudo dnf config-manager setopt rpmfusion-free-updates.enabled=1
sudo dnf config-manager setopt rpmfusion-nonfree.enabled=1
sudo dnf config-manager setopt rpmfusion-nonfree-updates.enabled=1

# update system and repositories
sudo dnf upgrade --refresh

# console
sudo dnf install alacritty fish

# tools
sudo dnf install cpupower htop screenfetch keepassxc vlc obs-studio meld blueman gparted seahorse file-roller

# security
sudo dnf install clamav

# virtualisation
sudo dnf install virt-manager qemu
sudo /usr/sbin/usermod -aG libvirt simonheise
sudo dnf install podman

# editors
sudo dnf install neovim emacs

# fonts
sudo dnf install dejavu-fonts-all fontawesome-6-free-fonts

# additional programs
sudo dnf install calibre thunderbird

#install windowmanager tools
sudo dnf install dunst brightnessctl wireplumber gammastep gammastep-indicator grim rofi slurp wl-clipboard pavucontrol network-manager-applet

# install sway
sudo dnf install sway swaybg python3-dbus-next python3-i3ipc

# install from personal repo
#TODO emacs packages cpupower-go
sudo dnf install nwg-panel

# install brave
sudo dnf install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install brave-browser

# programming
# TODO: jdtls, elixir-ls, gradle
sudo dnf install rustup golang gopls elixir elixir-doc erlang rust-analyzer rust-src

# osc as a cli for opensuse buildservice
sudo dnf install osc

# cosmic desktop
sudo dnf install cosmic-comp cosmic-launcher cosmic-panel cosmic-session cosmic-settings cosmic-applets

# niri
# TODO: cosmic-ext-extra-session
sudo dnf install niri

# from https://docs.fedoraproject.org/en-US/workstation-working-group/third-party-repos/
#sudo dnf install fedora-workstation-repositories
#sudo dnf config-manager addrepo rpmfusion-nonfree-nvidia-driver
#sudo dnf config-manager addrepo rpmfusion-nonfree-steam

# create key for secure boot
sudo dnf install kmodtool akmods mokutil openssl
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der

# install nvidia
# activate open kernel driver according to
# https://rpmfusion.org/Howto/NVIDIA#Kernel_Open
sudo sh -c 'echo "%_with_kmod_nvidia_open 1" > /etc/rpm/macros.nvidia-kmod'
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
# shouldn't be necessary since the driver was installed after activating the open kernel module
# sudo akmods --kernels $(uname -r) --rebuild

# gaming
sudo dnf install steam mangohud

# snapshots(see https://sysguides.com/install-fedora-41-with-full-disk-encryption-snapshot-and-rollback-support#6-install-and-configure-snapper)
sudo dnf install snapper libdnf5-plugin-actions

sudo cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions <<'EOF'
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"

# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -c\ number\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
EOF

# setup snapper 
#sudo umount /.snapshots
#sudo rm -r /.snapshots
#sudo snapper -c root create-config /
# read UUID e.g. by running sudo blkid | grep fedora_root | cut -d ' ' -f 2 | cut -d '=' -f 2 | cut -d '"' -f 2
#sudo mount -o subvol=@snapshots UUID=$rootUUID /.snapshots
#sudo chmod 750 /.snapshots/

# bottles
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.usebottles.bottles
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.heroicgameslauncher.hgl

# from personal repo
sudo dnf install veracrypt
sudo dnf install jdtls
sudo dnf install emacs-cape-git emacs-catppuccin-theme-git emacs-company-mode-git emacs-compat-git emacs-consult-git emacs-evil-git emacs-go-mode-git emacs-markdown-mode emacs-rust-mode-git emacs-spacemacs-theme-git emacs-yasnippet-git emacs-yasnippet-snippets-git elixir-ls codium

# switch ffmpeg with rpm-fusion ffmpeg
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

# install nvidia-container-toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-yum-or-dnf
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
sudo dnf config-manager setopt nvidia-container-toolkit-experimental.enabled=1
sudo dnf install nvidia-container-toolkit

# add Defaults targetpw to sudoers
sudo visudo
