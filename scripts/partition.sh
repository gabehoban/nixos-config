#!/usr/bin/env bash

set -e

print () {
    echo -e "\n\033[1m> $1\033[0m\n"
}

# Set DISK
select ENTRY in $(ls /dev/disk/by-id/);
do
    DISK="/dev/disk/by-id/$ENTRY"
    echo "Installing ZFS on $ENTRY."
    break
done

read -p "> Do you want to wipe all datas on $ENTRY ?" -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Clear disk
    wipefs -af $DISK
    sgdisk -Zo $DISK
fi

# EFI part
print "Creating EFI part"
sgdisk -n1:1M:+512M -t1:EF00 $DISK
EFI=$DISK-part1

# ZFS part
print "Creating ZFS part"
sgdisk -n2:0:0 -t2:bf01 $DISK
ZFS=$DISK-part2

# Inform kernel
partprobe $DISK

# Format boot part
sleep 1
print "Format EFI part"
mkfs.vfat $EFI

# Create ZFS pool
print "Create ZFS pool"
zpool create -f \
    -O acltype=posixacl       \
    -O xattr=sa               \
    -o ashift=12              \
    -R /mnt                   \
    -O mountpoint=none        \
    -O encryption=aes-256-gcm \
    -O keyformat=passphrase   \
    -O keylocation=prompt     \
    zroot $ZFS

# ZFS filesystems
print "Create ZFS volumes"
zfs create -o mountpoint=none zroot/root
zfs create -o mountpoint=legacy zroot/root/nixos
zfs create -o mountpoint=legacy zroot/home
zfs create -o mountpoint=legacy zroot/var

# Mount filesystems
print "Mount parts"
mount -t zfs zroot/root/nixos /mnt
mkdir /mnt/home
mount -t zfs zroot/home /mnt/home
mkdir /mnt/boot
mount $EFI /mnt/boot
mkdir /mnt/var
mount -t zfs zroot/var /mnt/var

rm -Rf /mnt/etc/nixos 2>/dev/null
git clone https://github.com/gabehoban/nixos-config /mnt/etc/nixos

# Select host configuration
print "Select host to setup :"
WORKDIR="/mnt/etc/nixos/hosts/" ; cd $WORKDIR
select HOST in $(ls);
do
    ln -s hosts/$HOST/configuration.nix ../

    # Generate configuration-hardware.nix
    print "Generate hardware configuration"
    nixos-generate-config \
        --root /mnt \
        --show-hardware-config > /mnt/etc/nixos/hosts/$HOST/hardware-configuration.nix
    break
done


# Set unstable channel
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --update

# Install
nixos-install


# Finish
echo -e "\e[32mAll OK"