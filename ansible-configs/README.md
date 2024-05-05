# Ansible playbooks 

This folder contains YAML configuration files used as playbooks for Ansible automation tool.

## Purpose: 

The YAML files in this folder serve as playbooks for Ansible, a powerful automation tool for managing and configuring systems. These playbooks define the tasks to be executed on remote hosts, facilitating the automation of various system administration tasks.

## Files: 

1. **update-nodes.yaml**
This playbook updates and upgrades apt packages on all hosts specified in the inventory. It utilizes Ansible's apt module to perform the package management tasks.

## Usage: 

To execute the playbooks in this folder, follow these steps: 

1. Ensure Ansible is installed on your system.
2. Create or modify an Ansible inventory file to define the hosts on which the playbooks will run. 
3. Run the desired playbook using the `ansible-playboook` command, specifying the playbook YAML file.

<br>

Example:
```bash
$ ansible-playbook -i inventory <filename>
```

## Contributing: 

Feel free to contribute additional playbooks or improvements to existing ones to enhance the automation capabilities of this repository.

