#!/bin/bash
#Included 2 below commands for kubernetes configuration but these are general to any containerization
#begins
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
#ends

growpart /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var
