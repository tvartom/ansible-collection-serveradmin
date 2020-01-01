tvartom.firewall
=====================

Setup firewalld for CentOS 7 as an Ansible-role:

Install role
------------

Create `requirements.yml` in your ansible playbook-folder.

    ---
    # Documentation:
    # https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
    
    - name: tvartom.firewall
      src: https://github.com/tvartom/ansible-role-firewall
      scm: git
      # version: "v1.0" # Omit for latest version.

Run:

    $ ansible-galaxy install -r requirements.yml -p roles/


Requirements
------------

CentOS 7

Role Variables
--------------

    firewall:
      services:
        - name: "dhcpv6-client"
          comment: "My optional comment"
        - name: "ssh"
        - name: "http"
        - name: "https"
      extra_ports:
        - port: 9999
          protocol: tcp
          comment: "My optional comment"
      forward_ports:
        - port: 80
          to_port: 8080
          protocol: tcp
          comment: "My service"

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      tasks:
         - include_role:
             name: tvartom.firewall
           var:
             firewall:
                extra_ports:
                  - port: 9999
                    protocol: tcp
                    comment: "My service"

           

License
-------

CC-BY-4.0

Author Information
------------------

tvartom
