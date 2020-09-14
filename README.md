# Serveradmin by tvartom

An Ansible Collection

## What is Serveradmin?

Serveradmin is an Ansible Collection for setting up a basic CentOS 8.2 web server.
The main purpose is to easily set up a server with sane security, and all in one configuration to build, deploy and host.
A server can also be run locally (As a virtual server (tested) or as Docker (not tested)) in `devmode`, offering the exact same setup as your production server.

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

If devmode is used:

* The security is lower, please do not expose the server to incoming connections from internet.
* All git repos for an application is initiated and shared with the host with Samba or NFS
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
* `data_migrations` - Configuration for generating scripts that copy databases and files from other servers.
* `backup` - Configuration for backup of this server

## Setup

### Configuration repository

TODO: Show example.
For now you probably have access to an already set up repo.

### CentOS

Serveradmin require currently CentOS 8.2.2004 (And isn't maintained to support older versions)

### As local virtual server

Download CentOS as ISO-image: https://www.centos.org/download/

If asked for operating system and `CentOS 8.2` is missing, choose `Red Hat Enterprise Linux 8.2 (rhel8.2)`

### CentOS setup

1. Choose English (United States) as OS language. (For Googlable error messages) Press Next.

2. Choose keyboard, this may differ from language (Removed unused).

3. Network & Host Name

Ethernet (enp1s0) enabled!

Host Name: Same as in Ansible inventory

4. Time & Date

Choose Time Zone and Network Time: On.

Do this after enabling network for the server.

5. Software Selection

Change to `Minimal Install`

6. Installation Destination

Leave default and confirm with `Done`.

7. Begin installation

Set Root Password and user if wanted. (The user will be set up by `<prefix>_ansible_serveradmin`, so not needed.)

Wait and Reboot!

9. From now on can you SSH to the machine.

To find ip-address login and run `ip addr` on the machine.
Use `ssh -A <ip address>` or Putty (with agent forwarding).

8. Login with main user or as root and run `sudo dnf update`

9. Continue with `Bootstrap a server`

### Bootstrap a server

When asked for `### Serveradmin-repository on Github ###` you need to give details for the configuration repo.

1. Run:
```
curl https://raw.githubusercontent.com/tvartom/ansible-collection-serveradmin/master/tools/bootstrap.sh -o bootstrap.sh
sudo bash bootstrap.sh
```

2. Log out, log in again. (With root if no user is created yet)

3. Run: `<prefix>_ansible_serveradmin` to set up all main components of the server

4. Log out, log in as main user (This should now be possible with public-key authentication)

5. Run: Any datamigration, if your applications is dependent on it. (Remember to have agent forward activated for your ssh-connection)

6. Run: `<prefix>_ansible_applications` to set up all application-instances on this server. This will configure nginx, redis, php, mariadb, sign ssl-certificate etc.

7. Only for devmode, Run `<prefix>_init_devmode` (This must be run by the devmode user)

8. Run: `<prefix>_deploy` for every application. This will pull down your source code, and deploy it.

### Devmode

See `Bootstrap a server` for setting up server.

Step 7 will initiate all git repos for your applications. These are placed in `/home/<devmode_user>/workspace` and accessible with Samba or NFS.

Step 8 gives you the option to deploy `devmode_infopage`. When you've done that, you can reach an infopage by opening that ip-address in your webbrowser.
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
