tvartom.auto_update_yum
=======================

Install and config yum-cron for CentOS 7 as an Ansible-role.

Install role
------------

Create `requirements.yml` in your ansible playbook-folder:

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.auto_update_yum
      src: https://github.com/tvartom/ansible-role-auto_update_yum
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/

Requirements
------------

CentOS 7

Role Variables
--------------

None

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      tasks:
        - include_role:
            name: tvartom.auto_update_yum

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
