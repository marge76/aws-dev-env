# Ansible

## Background

Ansible is used for:

* Provisioning/Configuring software
* uses yml script
* Jinja templating
* start with ansible for workspace playbook


## Setting up

### Local Machine

* IDE: VSCode
* Marketplace extension: Ansible

### Ansible Controller Machine

Download the latest version of ansible using the Python package manger 'pip'

```bash
sudo easy_install pip
sudo pip install ansible
```


## Inventory files

Inventory files allow you to group machines together. Default location = /etc/ansible/hosts

An example inventory file

```yaml
# Web Servers
web1 ansible_host=server1.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web2 ansible_host=server2.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web3 ansible_host=server3.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!

# Database Servers
db1 ansible_host=server4.company.com ansible_connection=winrm ansible_user=administrator ansible_password=Password123!

# Groups
[web_servers]
web1
web2
web3

[db_servers]
db1
```

#### Add aliases to the servers:

```txt
Syntax: alias FQDN(IP Address)=domain
Example:web ansible_host=server.example.com
```

Additional inventory parameters:

```txt
Connection type: ansible_connection (ssh/winrm/localhost)
Connection port: ansible_port (default 22)
User for remote connection: ansible_user
Password for user for rc: ansible_ssh_pass
Supply private key: ansible_ssh_private_key_file
```

e.g.

```yaml
web ansible_host=server.example.com ansible_connection=ssh ansible_user=admin ansible_ssh_pass=Password1!
```

Ansible creates one group by default: **all**

LOOKUP: Ansible Vault for storing passwords

### Demo

Request ansible to ping the target to check connectivity using inventory demo.txt

```yaml
$ ansible target1 -m ping -i demo.txt
target1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Organising groups of groups
Syntax:

```txt
[parent_group:children]
child_group1
child_group2
```

Working example:

```yaml
# Web Servers
web1 ansible_host=server1.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web2 ansible_host=server2.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web3 ansible_host=server3.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!

# Database Servers
db1 ansible_host=server4.company.com ansible_connection=winrm ansible_user=administrator ansible_password=Password123!


[web_servers]
web1
web2
web3

[db_servers]
db1

[all_servers:children]
web_servers
db_servers
```

## YAML

Key: Value pair based, just another way of visualising information, like XML or JSON.

Comments are denoted with #

List Style - ordered:

```yaml
Fruits:
-   Orange
-   Apple
```

'-' = element of an array.

The number of spaces before each property is key in YAML. There must be an equal number of spaces for items of the same type, additional spaces for subtypes etc.

Dictionary style - unordered:

```yaml
Banana:
    Calories: 105
    Fat: 0.4 g
    Carbs: 27 g
```

A list of dictionaries

```yaml
Fruits:
    -   Banana:
        Calories: 105
        Fat: 0.4g
        Carbs: 27g

    -   Grape:
        Calories: 62
        Fat: 0.3g
        Carbs: 16g
```

## Playbooks & Running Ansible

Playbooks are files containing commands in yml format that ansible runs.

Example

```yaml
#Simple Ansible Playbook

-  Run command1 on server1
-  Run command2 on server2
```

Formed of a single YAML file
    Play - defines a set of activities (tasks) to be run on hosts
        Task - an action to be performed on the host
            - Execute a command
            - Run a script
            - Install a package
            - Shutdown/restart

```yaml
#Simple Ansible Playbook1.yml
-
 name: Play 1
 hosts: localhost
 tasks:
    - name: execute command 'date'
      command: date

    - name: execute script on server
      script: test_script.sh

-
 name: Play 2
 hosts: localhost
 tasks:
    - name: Install httpd service
      yum:
        name: httpd
        state: present

    - name: Start web server
      service:
          name: httpd
          state: started
```

Each - before a new Play indicates that this is a new item in the list.

Lists are ordered. The order of entry in the list matters.

Hosts is set at a play level. Any number of hosts may be used, but the information regarding the host must be written in the inventory file first.

For commands that must be run by the sudo/root user, add become: true - this can be performed at task, play or playbook level.

```yaml
# Simple playbook to update yum and install wget
-
  name: update yum and install wget
  hosts: target_servers
  tasks:
    - name: update yum
      yum:
        name: '*'
        state: latest
    - name: install wget
      yum:
        name: wget
        state: present
  become: true # escalate user to root
```

### Running a playbook

Execute a playbook - note you cna add the --check flag to perform a 'dry run' first.

```yaml
ansible-playbook <playbook_file_name>.yml -i <inventory_file_name>.txt
```

More info can be obtained by using:

```yaml
ansible-playbook -help
```

### Demo

Create a playbook that pings all servers

```yaml
###playbook-pingtest.yaml
-
  name: Test connectivity to target server
  hosts: all
  tasks:
    - name: Ping test
      ping:
```

To run:

```yaml
ansible-playbook playbook-pingtest.yaml -i inventory.txt
```

Example

```yaml
# 1. Stop web services on web server nodes [web_nodes] - service httpd stop
# 2. Stop db services on db servers [db_nodes] - service mysql stop
# 3. Restart all servers simultaneously [all_nodes] - /sbin/shutdown -r
# 4. Start the database services on db servers - service mysql start
# 5. Start the web services on web servers - service httpd start

# Playbook file
-
 name: Stop the web services on web server nodes
 hosts: web_nodes
 tasks:
   -
     name: stop the httpd service
     command: service httpd stop
-
  name: Shutdown the database services on db server nodes
  hosts: db_nodes
  tasks:
   -
    name: stop mysql services
    command: service mysql stop
-
  name: Restart all servers (web and db) at once
  hosts: all_nodes
  tasks:
   -
     name: restart all servers
     command: /sbin/shutdown -r
-
  name: Start the database services on db server nodes
  hosts: db_nodes
  tasks:
   -
     name: start mysql services
     command: service mysql start
-
  name: Start the web services on web server nodes
  hosts: web_nodes
  tasks:
   -
     name: start httpd services
     command: service httpd start
```

## Modules

Different actions run by tasks are called modules.

Modules are categorised in to groups based on their functionality

  Modifying users, groups, hostnames, iptables, pinging

* System:
  service, cp, mv, mkdir
* Commands:
  commands, scripts, raw, expect, shell
* Files:
  Archive, copy, file, find lineinfile, replace, stat, template, unarchive
* Database:
  Mongo, mysql, postgresql
* Cloud:
  AWS, Azure,, Docker, Google, Rackspace etc
* Windows:
  Ansible for use with Windows environments, e.g: win_copy, win_command, win_domain, win_file, win_regedit

& more

### Command

Executes a command on a remote node

#### Parameters

chdir - cd in to this directory before running command.

creates - a filename or glob pattern, when it already exists this step will **not** run.

executable - change the shell used to execute the command. Should be an **absolute** path to the variable.

removes - a filename or glob pattern, when it does not exist this step will not run.

warn - if command warnings are on in ansible.cfg, do not warn about this particular line.

free_form - module takes a free form command to run - there is no parameter named 'free form' - the command input is the full command and path e.g. cat /etc/resolv.conf

### Script

Runs a local script on a remote node after transferring it:

1. Copy script to remote systems
2. Execute script on remote system

```yaml
...
  tasks:
    - name: run a script on a remote server
      script: /some/local/script.sh -arg1 -arg2
```

### Service

Manage services - start, stop restart
Must be used in a key:value pair format

The state must be described as:

- started
- stopped

```yaml
#sample playbook
-
  name: start services in order
  hosts: localhost
  tasks:
   - name: start db service
     service: name=postgresql-9.6 state=started
```

Note the above is equivalent to

```yaml
#sample playbook
-
  name: start services in order
  hosts: localhost
  tasks:
   - name: start db service
   - service:
       name: postgresql-9.6
       state: started
```

In yaml terms, name and state are properties of a service.

Why "started" and not "start"? We are instructing ansible to ensure that the service postgresql-9.6 is **started**, not to _start_ the service.
So, if postgresql-9.6 is not already **started**, start it.
If postgresql-9.6 is already started, do nothing.

#### Extra info

This is "Idempotency" - _an operation is idempotent if the result of performing it once is exactly the same result of performing it repeatedly without any intervening actions._

Ansible looks to get services to an _expected state_ and the idea of idempotency is encouraged by ansible - if you rerun an ansible script, ansible will check if the services are in the expected state, and if not, it will run the set commands.

### LINEINFILE

Search for a line in a file and replace it or add it if it doesn't exist

In the example playbook below, ansible checks if resolv.conf contains the following nameserver entries, if it doesn't it will add them. If the script is run again, the entries will **not** be added again, because LINEINFILE works on the concept of idempotency; the expected state is met.

```yaml
#Sample /etc/resolv.conf

nameserver 10.1.250.1
nameserver 10.1.250.2
```

### Demo

Execute a script and start the httpd service

```yaml
-
  name: Execute a script on all web server nodes and start httpd service
  hosts: web_nodes
  tasks:
    - name: Execute a script
      script: /tmp/install_script.sh
    - service:
        name: httpd
        state: started
```

Add a line to /etc/resolv.conf, execute a script and start a service. Note the different format: placement of - and "state: present"

```yaml
-
  name: Execute a script on all web server nodes and start httpd service
  hosts: web_nodes
  tasks:
    -
      lineinfile:
        path: /etc/resolv.conf
        line: 'nameserver 10.1.250.10'
    -
      name: Execute a script
      script: /tmp/install_script.sh
    -
      name: Start httpd service
      service:
        name: httpd
        state: present
```

## Variables

Stores information that varies with each host

You can define variables in a playbook, enclose variables with double curly braces '{{ }}' for use. This format is Jinja2 Templating.

When using variables in a playbook, you must be careful to use single quote marks ' ' depending on the situation. Format as follows:

```yaml
source: '{{ variable }}' # 1. when the variable is used exclusively as the parameter
source: Something{{variable}}Something # 2. when the variable forms part of the parameter
```

You can declare variables in the inventory.txt file

```txt
# Sample Inventory File

localhost ansible_connection=localhost nameserver_ip=10.1.250.10 snmp_port=160-161
```

```yaml
#Sample Playbook
-
  name: Update nameserver entry into resolv.conf file on localhost
  hosts: localhost
  tasks:
    -
      name: Update nameserver entry into resolv.conf file
      lineinfile:
        path: /etc/resolv.conf
        line: 'nameserver {{ nameserver_ip }}' # 2

    -
      name: Disable SNMP Port
      firewalld:
        port: '{{ snmp_port }}' # 1
        permanent: true
        state: disabled

```

You can also declare variables in the playbook

```yaml
-
  name: Update nameserver entry into resolv.conf file on localhost
  hosts: localhost
  vars:
    car_model: "BMW M3"
    country_name: USA
    title: "Systems Engineer"
  tasks:
    -
      name: Print my car model
      command: echo "My car's model is {{ car_model }}"

    -
      name: Print my country
      command: echo "I live in the {{ country_name }}"

    -
      name: Print my title
      command: echo "I work as a {{ title }}"
```

## Conditionals

Add conditions to tell ansible when a task should run.

== - comparison operator

Note the below is not a great example in practise, but it works to demonstrate conditionals. In practice, you should group the db_server separately to web_servers and run separate **plays** for each group.

```txt
#Inventory

web1 ansible_host=web1.company.com ansible_connection=ssh ansible_ssh_pass=P@ssW
web2 ansible_host=web1.company.com ansible_connection=ssh ansible_ssh_pass=P@ssW
web3 ansible_host=web1.company.com ansible_connection=ssh ansible_ssh_pass=P@ssW
db ansible_host=db1.company.com ansible_connection=ssh ansible_ssh_pass=P@ss

[all_servers] # Group
web1
web2
web3
db1
```

```yaml
# Playbook
-
  name: start services
  hosts: all_servers
  tasks:
    -
      service: name=mysql state=started
      when: ansible_host == "db1.company.com"
    -
      service: name=httpd state=started
      when: ansible_host == "web1.company.com" or "web2.company.com" or "web3.company.com"
```

Use the register directive to register or store the output of a module

```yaml
...
  tasks:
    -  command: service httpd status
       register: command_output

    -  mail:
           to: Admins <system.admins@company.com>
           subject: Service Alert
           body: 'Service {{ ansible_hostname }} is down.'
       when: command_output.stdout.find('down') != -1
```

The output of the command run will be stored in the variable command_output.

You can use inline conditionals such as <, >, =<, >=

```yaml
-
  name: Am in an Adult or a Child
  hosts: localhost
  vars:
    age: 25
  tasks:
    -
      command: echo "I am a Child"
      when: {{ age }} < 18

    -
      command: echo "I am an Adult"
      when: {{ age }} >= 18
```

Another example using find

```yaml
-
  name: Add name server entry if not already entered
  hosts: localhost
  tasks:
    - shell: cat /etc/resolv.conf
      register: command_output # saves the output of the command in to the variable command_output

    -
      shell: echo "nameserver 10.0.250.10" >> /etc/resolv.conf # runs when the IP entry 10.0.250.10 is not found
      when: command_output.stdout.find('10.0.250.10') == -1
```

## Loops

### WITH_ITEMS

A looping directive, useful for installing multiple packages using the same command.

```yaml
#Playbook
-
  name: Install Packages
  hosts: localhost
  tasks:
     - name: install dependencies via yum
       yum:
        name: "{{ packages }}"
        state: present
       vars:
        packages:
        - unzip
        - tar
```

Loop through vars

```yaml
-
  name: Install required packages
  hosts: localhost
  vars:
      packages:
      - httpd
      - binutils
      - glibc
      - ksh
      - libaio
      - libXext
      - gcc
      - make
      - sysstat
      - unixODBC
      - mongodb
      - nodejs
      - grunt

  tasks:
    -
      yum:
      name: "{{ packages }}"
      state: present
```

## Roles

### Directory Structure

Structuring code through packages, modules, classes and functions in ansible is handled with Roles.

In ansible, we have inventory files, variables and playbooks. This is where roles come in. Roles define a structure for your project and define standards on how files and folders are organised within the project. Roles allow us to reorganise playbooks in to modular components that are easier to handle and maintain.

The directory structure standard is as follows:

```txt
Ansible Project
| inventory.txt
| setup_applications.yml
| roles
| | webservers
| | - files
| | - templates
| | - tasks
| | - handlers
| | - vars
| | - defaults
| | - meta
```

```yaml
#Playbook
-
  name: set firewall config
  hosts: web
  roles:
    -  webservers
```

### Organising Playbooks

**include**  allows you to manage individual ansible playbooks in an individual master playbook

These individual playbooks could include tasks...

**vars_files** is used to _include_ vars.

```yaml
#Playbook
-
  name: set firewall config
  hosts: web
  vars_files:
          - variables.yml
  tasks:
          - include <playbook name>
```
