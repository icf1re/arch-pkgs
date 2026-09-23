#!/bin/bash
# 过滤系统自带包: CachyOS 安装器(calamares)首日 --noconfirm 装的包 + gnome 组 + 名字含 cachy/gnome
day=$(head -1 /var/log/pacman.log | cut -c2-11)
sys=$( {
    grep "^\[$day.*\[PACMAN\] Running 'pacman .*--noconfirm" /var/log/pacman.log |
        sed "s/.*Running 'pacman //;s/'$//" | tr ' ' '\n' | grep -E '^[a-z0-9]'
    pacman -Sgq gnome gnome-extra
} | sort -u)

pacman -Qqen | grep -vxF "$sys" | grep -vE 'cachy|gnome|^yay' > pkglist-repo.txt
pacman -Qqem | grep -vxF "$sys" | grep -vE 'cachy|gnome|^yay|clash-for-windows' > pkglist-aur.txt
flatpak list --columns=application --app > pkglist-flatpak.txt
