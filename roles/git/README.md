tvartom.git
===========

Install git and configure git for user account on CentOS as an Ansible role:

Install role
------------

Create `requirements.yml` in your ansible playbook-folder.

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.git
      src: https://github.com/tvartom/ansible-role-git
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/


Requirements
------------

CentOS 7

Dependencies
------------

* tvartom.ius_yum_repo

Example Playbook
----------------

    - hosts: servers
      tasks:
         - name: "Install Git"
           include_role:
             name: tvartom.git

         - name: "Configure git för user"
           include_role:
             name: tvartom.git
             tasks_from: config_git_for_user
           vars:
             user:
               name: "användarenamn" # Linux user-name
               fullname: "My full name" # Optional: Default is user.name
               email: "my.email@example.com" #Optional: Default is "user.name@inventory_hostname"

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
