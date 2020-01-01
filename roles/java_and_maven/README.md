tvartom.java_and_maven
======================

Install java and maven on CentOS as an Ansible role.

Install role
------------

Create `requirements.yml` in your ansible playbook-folder:

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.java_and_maven
      src: https://github.com/tvartom/ansible-role-java_and_maven
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
            name: tvartom.java_and_maven

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
