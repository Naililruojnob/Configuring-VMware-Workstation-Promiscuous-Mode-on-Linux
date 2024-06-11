#!/bin/bash  
  
# Change the group of the /dev/vmnet* device  
chgrp vmware-promiscuous /dev/vmnet*  
# Modify permissions of the /dev/vmnet* device  
chmod g+rw /dev/vmnet*
