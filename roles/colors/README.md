tvartom.colors
==============

A role used to register variables with colorcodes for Bash.

Install role
------------

Create `requirements.yml` in your ansible playbook-folder:

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.colors
      src: https://github.com/tvartom/ansible-role-colors
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/

Requirements
------------

A ANSI terminal.

Role Variables
--------------

The roll will return usefull color-codes in `yamlcolors` and `bashcolors`.

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      tasks:
        - include_role:
            name: tvartom.colors


Example Usage
----------------

In a task:

    - pause:
        prompt: |
          I {{ yamlcolors.Red }}love{{  yamlcolors.NC }} you!
        seconds: 0



In a bash-script-template:

    #!/bin/sh
    echo -e "I {{ bashcolors.Red }}love{{ bashcolors.NC }} you!"

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
