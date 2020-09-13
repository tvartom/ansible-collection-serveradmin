# Ansible Collection - tvartom.serveradmin

Documentation for the collection.

## Setup

1. Serveradmin require currently CentOS 8.2.2004.

## As local virtual mashine

Download CentOS as ISO-image: https://www.centos.org/download/

If asked for operating system and `CentOS 8.2` is missing, choose `Red Hat Enterprise Linux 8.2 (rhel8.2)`

### CentOS setup

1. Choose English (United States) as OS language. (For Googlable error messages) Press Next.

2. Choose keyboard, may be different to language.

3. Network & Host Name

Ethernet (enp1s0) enabled!

Host Name: Same as in Ansible inventory

4. Time & Date

Choose Time Zone and Network Time: On.

Do this after enabled network for server.

5. Software Selection

Change to `Minimal Install`

6. Installation Desitnation

Leave default and confirm with `Done`.

7. Begin installation

Set Root Password and Create a main user. Make main user administrator (sudoer).

Wait and Reboot!

9. From now on can you ssh to the machine.

To find ip-address login and run `ip addr` on the machine.
Use `ssh -A <ip address>` or Putty (with agent forwarding).

8. Login with main user and run `sudo dnf update`







## Bootstrap a server

Run:
```
curl https://raw.githubusercontent.com/tvartom/ansible-collection-serveradmin/master/tools/bootstrap.sh -o bootstrap.sh
sudo bash bootstrap.sh
```


## License

MIT License

Copyright (c) 2020 Tvako AB

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next paragraph) shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.