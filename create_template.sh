#!/bin/bash

# Default values (can be overridden by command-line arguments)
VMID=""
VMNAME="debian12-cloud-ct"
STORAGE="local-lvm"
QCOW_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
QCOW_FILE="debian12-cloud.qcow2"
MEMORY=8192
CORES=4
BRIDGE="vmbr0"

# Function to find a free VMID
find_free_vmid() {
  local vmid=100
  while qm status "$vmid" &> /dev/null; do
    vmid=$((vmid + 1))
  done
  echo "$vmid"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vmid) VMID="$2"; shift 2 ;;
    --vmname) VMNAME="$2"; shift 2 ;;
    --storage) STORAGE="$2"; shift 2 ;;
    --qcow_url) QCOW_URL="$2"; shift 2 ;;
    --qcow_file) QCOW_FILE="$2"; shift 2 ;;
    --memory) MEMORY="$2"; shift 2 ;;
    --cores) CORES="$2"; shift 2 ;;
    --bridge) BRIDGE="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

# Find free VMID if not provided
if [[ -z "$VMID" ]]; then
  VMID=$(find_free_vmid)
  echo "Free VMID found: $VMID"
fi

echo "Downloading qcow2 from $QCOW_URL to $QCOW_FILE..."
wget -O "$QCOW_FILE" "$QCOW_URL"

echo "Creating Proxmox VM..."
qm create "$VMID" --name "$VMNAME" --memory "$MEMORY" --cores "$CORES" --net0 virtio,bridge="$BRIDGE"

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
