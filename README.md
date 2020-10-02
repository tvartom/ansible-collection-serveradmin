# Serveradmin by tvartom

An Ansible Collection

## What is Serveradmin?

Serveradmin is an Ansible Collection for setting up a basic CentOS 8.2 web server.
The main purpose is to easily set up a server with sane security, and all in one configuration to build, deploy and host.
A server can also be run locally (As a virtual server) in _`devmode`_, offering the exact same setup as your production server.

It has been developed over time as I needed a lot of servers with similar setup, and want to be able to improve and update all servers at once.

Basic components:

* Nginx
* MariaDB
* PHP
* NodeJs
* Redis
* Encrypted backups with Rsnapshot
* SSL-certificate with Letsencrypt (with updates) or Self signed

* When logging in to the server, an admin user sees a splash-screen with information such as valid certificates, last backup and basic help of scripts to manage this server.
* An application is running as a dedicated user, with little access to the rest of the server, and none to other applications.
* Deploy script is generated, which pulls source from a repo, pushes back the version as an annotated git tag, builds the app and deploys it. No need for any extra build server like Jenkins or be dependent on Github Actions.

* As it is just an Ansible script, you can stop using it at any time, and configure your server as you like.

If _devmode_ is used:

* The security is lower, please do not expose the server to incoming connections from internet.
* All git repos for an application is initiated and shared with the host with VirtualBox Shared folder, Samba or NFS
* Debug features are enabled. (Xdebug (TODO))

The Ansible Collection doesn't work stand-alone, it needs a Git repository with configuration for a server or a group of servers.
The configuration repo contains this configuration in `group_vars/` and `host_vars/`:

Repo-global variables:
* `serveradmin` - Where this configuration repo is hosted. (On github)
* `organisation` - A name, a prefix for all commands, and a splash screen with ASCII-art
* `applications` - A list of configuration a all applications
* `users_all` - A list of all users for the system, including public keys

Variables normally set up per host:
* `application_instances` - A list of selected instances from `applications` with settings for this host, like name of environment (dev, test, prod etc), database connection and domain-names.
* `users` - A list of admin users from `users_all` to add on this host
* `data_migrations` - Configuration for generating scripts to copy databases and files from other servers.
* `backup` - Configuration for backup of this server

## Setup

### Configuration repository

TODO: Show example.
For now you probably have access to an already set up repo.

### As a virtual machine (VM) on VirtualBox

To understand the network for VirtualBox, here is a nice guide: [nakivo.com/blog/virtualbox-network-setting-guide](https://www.nakivo.com/blog/virtualbox-network-setting-guide/)

Notice: **Never** use _Bridged Adapter_ with Serveradmin in _devmode_. This will open up your database and code to the world outside your computer.

First create a network in VirtualBox to be used with the `Host-only Adapter`. `Tools` -> `Network` -> `Create`. It will be named **`vboxnet0`**. Enable `DHCP Server`. (This is **not** the same as `Preferences` -> `Network` -> `NAT Networks`, which are called `NatNetwork`)

Create a new VM. (`Machine` -> `Create`). Make sure to make the maximum capacity of the disc big enough. It is growing dynamicly, so it will not will fill up your harddrive until you filled it.

Before running the VM, go into settings:

**Network:**

> You need 2 network adapters:
> * Adapter 1: `Host-only Adapter` with `vboxnet0`. This is used to connect from your host (your computer) to the VM.
> * Adapter 2: `NAT` For internet-connection **from** the VM.

**Shared Folders:**

> For _devmode_:
> Share a folder with the `Folder Name`: `workspace`.


Klick **Start** in VirtualBox to launch. You will be asked `Select start-up disk`. Choose the ISO-image for CentOS. See `CentOS`for next step.

To escape your trapped mouse-pointer in VirtualBox use **Right Ctrl**.

### CentOS

Serveradmin require currently CentOS 8.2.2004 (And isn't maintained to support older versions)

### On AWS

Search for `ami-0474ce84d449ee66f` for `8.2.2004` in `eu-north-1`, or look at [wiki.centos.org/Cloud/AWS](https://wiki.centos.org/Cloud/AWS) for other regions.

Don't foreget to setup auto-recover [Amazon docs: UsingAlarmActions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingAlarmActions.html)

### As local virtual server

Download CentOS Minimal ISO-image: [centos.org/download](https://www.centos.org/download/)

If asked for operating system and `CentOS 8.2` is missing, choose `Red Hat Enterprise Linux 8.2 (rhel8.2)`

### CentOS setup

#### 1. Choose English (United States) as OS language. (For Googlable error messages) Press Next.

#### 2. Choose keyboard, this may differ from language (Removed unused).

#### 3. Network & Host Name

Enable **all** network adapters.
Ethernet (enp?s?) enabled!

Host Name: Same as in Ansible inventory

#### 4. Time & Date

Choose Time Zone and Network Time: On.

Do this after enabling network for the server.

#### 5. Software Selection

Change to `Minimal Install`

#### 6. Installation Destination

Leave default and confirm with `Done`.

#### 7. Begin installation

Set Root Password and user if wanted. (The user will be set up by `<prefix>_ansible_serveradmin`, so not needed.)

Wait and Reboot!

#### 8. Log in as `root` to make sure your network is set up and find your ip-address.

Run `nmcli`.

CentOS setup seems to sometimes fail activate all network interfaces/connections for interfaces.
Run: `nmcli --fields name,autoconnect connection show` to see connection-names and if `ONBOOT=yes` in set in `/etc/sysconfig/network-scripts/ifcfg-<connection-name>`.

To activte missing connections and set `ONBOOT=yes`, run: `nmcli connection modify <connection-name> autoconnect yes` for every connection.

Run: `nmcli` again to make sure everything looks ok, and find your new ip-address.

(`ip addr` is an alternative to find your ip-address.)
 
#### 9. From now on can you SSH to the machine.

Use `ssh -A root@<ip address>` or Putty.

#### 10. Continue with `Bootstrap a server`

### Bootstrap a server

When asked for `### Serveradmin-repository on Github ###` you need to give details for the configuration repo.

#### 1. Log in as root or a any sudo-user

#### 2. Run:
```
curl https://raw.githubusercontent.com/tvartom/ansible-collection-serveradmin/master/tools/bootstrap.sh -o bootstrap.sh
sudo bash bootstrap.sh
```

#### 3. Reboot, log in again. (With root if no sudo-user for serveradmin is created yet)

#### 4. Run: `<prefix>_ansible_serveradmin` to set up all main components of the server

#### 5. Log out, log in as a sudo-user

It should now be possible with public-key authentication with the sudo-users. The sudo-users must be specified in the serveradmin config.
Use `ssh -A <ip address>` or Putty. Activate agent forwarding.

#### 6. Only for devmode with VirtualBox Shared folders

Run: `<prefix>_ansible_vboxsf`

#### 7. Run: Any datamigration, if your applications is dependent on it.

Remember to have agent forward activated for your ssh-connection

#### 8. Run: `<prefix>_ansible_applications` to set up all application-instances on this server. This will configure nginx, redis, php, mariadb, sign ssl-certificate etc.

#### 9. Only for devmode

Run `<prefix>_init_devmode` (This must be run by the devmode user)

#### 10. Run: `<prefix>_deploy` for every application. This will pull down your source code, and deploy it.

### Devmode

See `Bootstrap a server` for setting up server.

Step 9 will initiate all git repos for your applications. These are placed in `/home/<devmode_user>/workspace` and accessible with VBox shared folders, Samba or NFS.

Step 10 gives you the option to deploy `devmode_infopage`. When you've done that, you can reach an infopage by opening that ip-address in your webbrowser.
The page gives you some basic information including config to paste in your local hosts-file, to be able to access your applications on the server.

### Access local database

MariaDB doesn't listen to any port on any network interface. (Not even localhost).

All connection to the database are made through the unix socket `/`.

To connect to it from an outside DB-client, you need to set up a SSH-tunnel exposing the unix-socket.

`ssh -A -L 127.0.0.1:3307::/var/lib/mysql/mysql.sock <address to server>`

If you connect with Putty, this isn't possible. After you're connected, you can expose the socket to a network interface with a local SSH-connection. Do this only on a local virtual machine.

`ssh -L <ip-address-of-local-network-interface>:3307:/var/lib/mysql/mysql.sock localhost`

Instead of `<ip-address-of-local-network-interface>`, `*` can be used, but be sure to not expose it to internet, and it also possible to do to an external server.

## License

MIT License

Copyright (c) 2020 Tvako AB

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next paragraph) shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
