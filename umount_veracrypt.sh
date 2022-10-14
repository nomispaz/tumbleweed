#!/bin/bash
sudo umount /mnt/veramount
sudo rm -r /mnt/veramount
sudo cryptsetup --veracrypt --type tcrypt close /dev/mapper/veramount
