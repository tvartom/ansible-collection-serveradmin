#!/bin/bash

# Run this script as with:
# $ curl https://raw.githubusercontent.com/tvartom/ansible-collection-serveradmin/master/tools/bootstrap.sh -o bootstrap.sh && sudo bash bootstrap.sh
#
# You need a serveradmin-repository with settings for this server.
# E.g.

function pause(){
   read -p "$*"
}

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

echo "### Serveradmin-repository on Github ###"
SA_REPO_HOST="github.com"
read -p "Username on $SA_REPO_HOST for owner of serveradmin-repository: " SA_REPO_USER
read -p "Name of ${SA_REPO_USER}'s serveradmin-repository: " SA_REPO_NAME
SA_REPO="git@$SA_REPO_HOST:/$SA_REPO_USER/$SA_REPO_NAME.git"
echo $SA_REPO;

echo ""
echo "### Serveradmin settings ###"
SA_INVENTORY_NAME_DEFAULT="$(hostname)"
read -p "Name of this server in inventory-file [$SA_INVENTORY_NAME_DEFAULT]: " SA_INVENTORY_NAME
SA_INVENTORY_NAME="${SA_INVENTORY_NAME:-$SA_INVENTORY_NAME_DEFAULT}"

SA_USER_DEFAULT="serveradmin"
read -p "Name of servadmin-user [$SA_USER_DEFAULT]: " SA_USER
SA_USER="${SA_USER:-$SA_USER_DEFAULT}"

SA_PATH_DEFAULT="/opt/$SA_USER"
read -p "Path to serveradmin [$SA_PATH_DEFAULT]: " SA_PATH
SA_PATH="${SA_PATH:-$SA_PATH_DEFAULT}"
echo ""

SYSTEM_USER_HOME="/home/system"
echo -n "Make sure '$SYSTEM_USER_HOME' exists... "
mkdir -p "$SYSTEM_USER_HOME"
chmod u=rwx,g=rx,o=rx "$SYSTEM_USER_HOME"
echo -e "Done\n"

SA_USER_HOME="$SYSTEM_USER_HOME/$SA_USER"
if ! id -u $SA_USER > /dev/null 2>&1; then
	echo -n "Creating user '$SA_USER'... "
	useradd --system --create-home --home "$SA_USER_HOME" "$SA_USER"
	echo -e "Done\n"
else
	echo -e "User '$SA_USER' already exists.\n"
fi

mkdir -p "$SA_USER_HOME/.ssh"
chown $SA_USER:$SA_USER "$SA_USER_HOME/.ssh"
chmod u=rwx,g=,o= "$SA_USER_HOME/.ssh"

SA_DEPLOY_KEY="$SA_USER_HOME/.ssh/deploy_${SA_REPO_HOST}_${SA_REPO_USER}_${SA_REPO_NAME}"
SA_DEPLOY_KEY_COMMENT="${SA_USER}@${SA_INVENTORY_NAME} $(date +"%Y-%m-%d")"

if [ ! -f "$SA_DEPLOY_KEY" ]; then
	echo -n "Generating deploy-key... "
	sudo -u $SA_USER \
			ssh-keygen -b 4096 \
					-t rsa \
					-q \
					-N "" \
					-f "$SA_DEPLOY_KEY" \
					-C "$SA_DEPLOY_KEY_COMMENT"
	echo -e "Done\n"
else
	echo -e "Deploy key already exists.\n"
fi

echo "Add key as a read-only deploy-key on Github:"
echo "1. Log in as '$SA_REPO_NAME' on github.com."
echo "2. Goto https://$SA_REPO_HOST/$SA_REPO_USER/$SA_REPO_NAME/settings/keys"
echo "3. Press 'Add deploy key'"
echo "4. Fill in:"
echo "     Title:"
echo "$SA_DEPLOY_KEY_COMMENT"
echo "     Key: "
ssh-keygen -y -f "$SA_DEPLOY_KEY"
echo ""
echo "5. Press 'Add key'"
echo ""
pause 'Press [Enter] when done to continue...'

# Använder yum som fungerar både på CentOS 7 och 8.
echo "Installing Git and Python3 with pip..."
yum install git python3 python3-pip
echo "Installing Ansible with pip to get latest version..."
sudo -u $SA_USER pip3 install --user ansible

echo -n "Creating workspace for serveradmin... "
mkdir -p "$SA_PATH/workspace"
chown -R $SA_USER:$SA_USER "$SA_PATH"
chmod -R u=rwx,g=rwx,o=rx "$SA_PATH"
echo -e "Done\n"

SA_PATH_REPO="$SA_PATH/workspace/serveradmin"

if [ ! -d "$SA_PATH_REPO/.git" ]; then
	echo "Cloning serveradmin-repo..."
	sudo -u $SA_USER git -c core.sshCommand="ssh -i $SA_DEPLOY_KEY" clone --recursive $SA_REPO "$SA_PATH/workspace/serveradmin"
else
	cd $SA_PATH_REPO
	sudo -u $SA_USER git -c core.sshCommand="ssh -i $SA_DEPLOY_KEY" pull --recurse-submodules
fi

PLAYBOOK_TO_RUN="temp_playbook-bootstrap.yml"
echo -e \
"---\n"\
"- import_playbook: collections/ansible_collections/tvartom/serveradmin/playbooks/playbook-serveradmin.yml\n"\
"  tags:\n"\
"    - never\n"\
"    - bootstrap"\
  | sudo -u $SA_USER tee -a "$SA_PATH_REPO/$PLAYBOOK_TO_RUN" > /dev/null

cd "$SA_PATH_REPO"
sudo -u "$SA_USER" ansible-playbook --extra-vars "target='$SA_INVENTORY_NAME' connection_type='local'" --tags bootstrap "$PLAYBOOK_TO_RUN"

