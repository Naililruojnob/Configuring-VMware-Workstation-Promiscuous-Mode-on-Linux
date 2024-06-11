# Configuring-VMware-Workstation-Promiscuous-Mode-on-Linux

**Resolving Promiscuous Mode Issues in VMware Workstation on Linux**

To address promiscuous mode issues, it's necessary to grant permissions to your users on the `vmnet` interfaces. This requires creating a group:

1. **Create a Group:**
   
   ```bash
   sudo groupadd vmware-promiscuous
   ```

2. **Add Your User to the Group:**
   
   ```bash
   sudo usermod -aG vmware-promiscuous <user>
   ```

   Replace `<user>` with your actual username.

Since VMware resets permissions on `vmnet` interfaces after each restart, we need to create a script for automating permission assignment.

3. **Create a Script:**
   
   Create a script named `configure_vmnet.sh` in `/usr/local/bin/`.

   ```bash
   #!/bin/bash  

   # Change the group of the /dev/vmnet* device  
   chgrp vmware-promiscuous /dev/vmnet*  
   # Modify permissions of the /dev/vmnet* device  
   chmod g+rw /dev/vmnet*
   ```

4. **Create a Systemd Service:**
   
   Create a service file named `configure_vmnet.service` in `/etc/systemd/system/`.

   ```conf
   [Unit]  
   Description=Configure VMNet Devices  
   After=vmware-networks.service  
   Requires=vmware-networks.service  

   [Service]  
   Type=oneshot  
   ExecStart=/usr/local/bin/configure_vmnet.sh  

   [Install]  
   WantedBy=multi-user.target
   ```

   This service will execute the script after VMware services are started during boot.

Now, enable and start the service:

```bash
sudo systemctl enable configure_vmnet.service
sudo systemctl start configure_vmnet.service
```

This setup ensures that permissions are correctly configured for `vmnet` interfaces on each system boot, resolving promiscuous mode issues in VMware Workstation on Linux.
