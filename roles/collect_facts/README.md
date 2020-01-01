tvartom.collect_facts
====================

An Ansible role to collect facts from var/files and the host.

* Read variables in `/var/*.yml` from your playbook.
* Read variables from `/root/host_vars.yml` on the host.
* Use `ansible_facts` and make a readable `diskpace_message`.

Read variables on the host is an alternative to ansible-vault.

Install role
------------

Create `requirements.yml` in your ansible playbook-folder:

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.gather_facts
      src: https://github.com/tvartom/ansible-role-gather_facts
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/


Usage
------------

To read variable form the host you need `facts_gather.host_vars_from_host` set to true and
create `/root/host_vars.yml` on the root.
Make sure only root can access it.

Example:

    ---
    mariadb:
      root_password: "MY SECRET PASSWORD"

    my_private_key: >-
      SECRET SECRET SECRET
      SECRET SECRET SECRET

Role Variables
--------------

Return variables:

* Any given in the files with variables.
* `diskspace_message`

Example Playbook
----------------

    - hosts: servers
      tasks:
        - include_role:
            name: tvartom.gather_facts
            tasks_from: gather_facts
          vars:
            facts_options:
              var_files:
                - users
                - system
              host_vars_from_host: true
              diskapace_message: true
          tags:
            - always

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
