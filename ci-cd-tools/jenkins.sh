# #!/bin/bash
# #Included 2 below commands for kubernetes configuration but these are general to any containerization
# #begins
# ARCH=amd64
# PLATFORM=$(uname -s)_$ARCH
# #ends

# growpart /dev/nvme0n1 4
# lvextend -l +50%FREE /dev/RootVG/rootVol
# lvextend -l +50%FREE /dev/RootVG/varVol
# xfs_growfs /
# xfs_growfs /var


#!/bin/bash
#resize disk from 20GB to 50GB
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/RootVG/rootVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /
xfs_growfs /var/tmp
xfs_growfs /var

curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install fontconfig java-17-openjdk jenkins -y

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins