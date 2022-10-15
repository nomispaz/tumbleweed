# tumbleweed_afterinstall.sh 
contains commands to recreate my system after a fresh install.
it includes
- change of hostname
- lock packages and patterns for zypper dup command
- installation and initial run of rkhunter to check for rootkits
- third party repository packman (only essentials) is added to download mediacodecs
- codecs and vlc are downloaded and installed from packman
- installation of several apps
- add environment parameter to enable wayland for firefox install of x-wayland
- add flathub for obs-studio since this doesn't exist in the opensuse repos and the one in packman is too old
- activate shell zsh with personal setup (kind of similar to manjaro-setup)
- enable libvirtd service to enable virtual machines
- enable dkms service so that nvidia and tuxedo drivers are automatically updated with a kernel update
- install tuxedo-driver for keyboard backlight for my laptop model (should work with many xmg or clevo models)
- copy of thunderbird profiles from backup
- workflow to install nvidia drivers from source

# install_firefox_extensions.sh 
contains the commands to download the latest version of the firefox extensions I use and to instal them

# mount_veracrypt.sh and unmount_veracrypt.sh 
contain commands to mount and unmount veracrypt volumes using cryptsetup since veracrypt is not available in opensuse repos.
