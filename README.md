# Proxmox VM Cloud-Init Template Creation Script

This bash script automates the creation of a Cloud-Init virtual machine within a Proxmox VE environment.

**Important Note:** This script is designed to be executed directly within the shell of a Proxmox VE node.

## Usage

1.  **Save the Script:**
    * Save the script to a file (e.g., `create_template.sh`).
2.  **Make the Script Executable:**
    * Run `chmod +x create_template.sh` to make the script executable.
3.  **Run the Script:**
    * Execute the script with `./create_template.sh`.

## Passing Parameters

The script supports passing parameters via command-line arguments, allowing you to customize the template creation. Here's a list of available parameters:

* `--vmid`: The VMID for the new VM (if not provided, a free VMID will be automatically assigned).
* `--vmname`: The name of the new VM template.
* `--storage`: The storage location for the VM disk and cloud-init drive.
* `--qcow_url`: The URL of the Cloud-Init qcow2 image.
* `--qcow_file`: The filename to save the downloaded qcow2 image as.
* `--memory`: The amount of RAM (in MB) for the VM.
* `--cores`: The number of CPU cores for the VM.
* `--root_disk_size`: The size of the root disk (in GB).
* `--bridge`: The network bridge to use for the VM.

**Example Usage:**

```bash
./create_template.sh --vmid 200 --vmname my-debian-vm --memory 4096 --storage local-lvm --bridge vmbr0 --qcow_url "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2" --qcow_file debian12-cloud.qcow2
```

Official Cloud Images:

- Fedora: https://download.fedoraproject.org/pub/fedora/linux/releases/41/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2
- Debiaa: https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
- Ubuntu: https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img

## Scheduling with Cron

You can schedule this script to run periodically using cron, ensuring your Proxmox environment always has an up-to-date Cloud-Init template.

1.  **Open Crontab:**
    * Run `crontab -e` to open the crontab editor.
2.  **Add Cron Job:**
    * Add a line to the crontab file specifying the schedule and the script's path. For example, to run the script daily at 3:00 AM, add the following line:

    ```cron
    0 3 * * * /path/to/create_template.sh
    ```

    * Replace `/path/to/create_template.sh` with the actual path to your script.
    * You can customize the schedule using cron syntax. For example, `0 0 * * 0` will run the script every Sunday at midnight.
3.  **Save and Exit:**
    * Save the crontab file and exit the editor. Cron will automatically run the script according to the schedule.
