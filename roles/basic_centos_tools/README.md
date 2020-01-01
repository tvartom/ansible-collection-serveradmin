tvartom.basic_centos_tools
==========================

Some basic setup for CentOS 7 as an Ansible-role.

Install role
------------

Create `requirements.yml` in your ansible playbook-folder:

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.basic_centos_tools
      src: https://github.com/tvartom/ansible-role-basic_centos_tools
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/


Requirements
------------

CentOS 7

Role Variables
--------------

basic.timezone
basic.package_to_install

Look at defaults in defaults/main.yml

Dependencies
------------

* tvartom.ius_yum_repo

Example Playbook
----------------

    - hosts: servers
      tasks:
         - include_role:
             name: tvartom.basic_centos_tools
           vars:
             basic:
               timezone: "Europe/Stockholm"
               package_to_install:
                 - mc
                 - rsync

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
