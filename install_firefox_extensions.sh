#!/bin/bash

#Download latest version of the extensions
wget -P /data/install/firefox https://www.eff.org/files/privacy-badger-latest.xpi
wget -P /data/install/firefox https://addons.mozilla.org/firefox/downloads/file/4003969/ublock_origin-latest.xpi
wget -P /data/install/firefox https://www.eff.org/files/https-everywhere-latest.xpi /data/install/firefox

#Install the extensions
for f in /data/install/firefox/*
do
  echo "Installing firefox extension $f ..."
  firefox $f
done
