tvartom.menu
============

A menu to prompt the user for input as an Ansible-role.

Install role
------------

Create `requirements.yml` in your ansible playbook-folder:

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.menu
      src: https://github.com/tvartom/ansible-role-menu
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/

Read more: 
https://opencredo.com/blogs/reusing-ansible-roles-with-private-git-repos-and-dependencies/

Requirements
------------

None

Role Variables
--------------

See example for the parameter `menu`.

Return `value` from choosen menu item will be in the variable `menu_result`.

Dependencies
------------

* tvartom.colors

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      tasks:
        - name: "Menu"
          include_role:
            name: tvartom.menu
            tasks_from: menu
          vars:
            menu:
              caption: "This is the caption of the menu!"
              question: "Choose alternative:"
              options:
               - name: "Alternative 1"  # Required
                 value: 100             # Optional: Value to return in {{ menu_result }}, default value is {{ name }}
                 option: "all"          # Optional: Option for user to choose
                 default: true          # Optional: Is this alternative the default one? (Just press enter)
               - name: "Alternative 2"
               - { name: "Alternative 3", value: 10 }

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
