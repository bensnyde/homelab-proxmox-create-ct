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
