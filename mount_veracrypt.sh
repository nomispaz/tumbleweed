#!/bin/bash
sudo mkdir /mnt/veramount
sudo cryptsetup --veracrypt --type tcrypt open /run/media/nomispaz/nixos_root/home/simonheise/Documents/_privat/Simon_Privat veramount
sudo mount /dev/mapper/veramount /mnt/veramount
