#!/bin/bash
sudo mkdir /mnt/veramount
sudo cryptsetup --veracrypt --type tcrypt open <pathToVeracryptFile>/<VeracryptFile> veramount
sudo mount /dev/mapper/veramount /mnt/veramount
