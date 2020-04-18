#!/bin/bash

# Run this script as with:
# $ curl https://raw.githubusercontent.com/tvartom/ansible-collection-serveradmin/master/tools/bootstrap.sh | sudo bash
#
# You need a serveradmin-repository with settings for this server.
# E.g.

echo "############################################"
echo "### BOOTSTRAP for Serveradmin by Tvartom ###"
echo "############################################"
echo ""
echo "Bootstrap this server with Ansible and the Serveradmin-repository."
echo ""
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
echo "### Serveradmin-repository ###"
read -p "Host [github.com]: " REPO_HOST

REPO_HOST="${REPO_HOST:-github.com}"
echo $REPO_HOST
exit

mkdir "/home/system"
chmod u=rwx,g=rx,o=rx "/home/system"

useradd --system -d /home/system/serveradmin -G wheel,adm serveradmin

mkdir "/home/system/serveradmin/.ssh"
chmod u=rwx,g=,o= "/home/system/serveradmin/.ssh"

#Bara deploy-key ska skapas!
#    comment: "Deploykey for {{ clone_repo.user }}@{{ inventory_hostname}}"

sudo -u serveradmin \
		ssh-keygen -b 4096 \
				-t rsa \
				-q \
				-N "" \
				-f "/home/system/serveradmin/.ssh/deploy_github.com_tvartom_devops-homeservers"
				-C "serveradmin@$(hostname) $(date +"%Y-%m-%d)"

# Använder yum som fungerar både på CentOS 7 och 8.

yum install python3 python3-pip

sudo -u serveradmin pip install --user ansible

mkdir -p /opt/serveradmin/workspace
chown -R serveradmin:serveradmin /opt/serveradmin
chmod -R u=rwx,g=rwx,o=rx /opt/serveradmin

