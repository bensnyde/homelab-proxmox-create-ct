#!/bin/bash

VMID=108
VMNAME="debian12-cloud-ct"
STORAGE="local-lvm"
QCOW_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
QCOW_FILE="debian12-cloud.qcow2"
MEMORY=8192
CORES=4
ROOT_DISK_SIZE=8

echo "Downloading Debian 12 Cloud-Init qcow2..."
wget -O "$QCOW_FILE" "$QCOW_URL"

echo "Creating Proxmox VM..."
qm create "$VMID" --name "$VMNAME" --memory "$MEMORY" --cores "$CORES" --net0 virtio,bridge=vmbr0

echo "Importing and attaching qcow2 disk..."
qm importdisk "$VMID" "$QCOW_FILE" "$STORAGE"
qm set "$VMID" --scsi0 "$STORAGE:vm-$VMID-disk-0"

echo "Adding cloud-init drive..."
qm set "$VMID" --scsi1 "$STORAGE:cloudinit"

echo "Setting boot disk..."
qm set "$VMID" --boot order=scsi0

echo "Converting to template..."
qm template "$VMID"

echo "Cleaning up..."
rm "$QCOW_FILE"

echo "VM $VMID ($VMNAME) created and converted to template."
