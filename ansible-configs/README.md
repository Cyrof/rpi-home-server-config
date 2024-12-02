# Ansible playbooks 

This folder contains YAML configuration files used as playbooks for Ansible automation tool.

## Purpose: 

The YAML files in this folder serve as playbooks for Ansible, a powerful automation tool for managing and configuring systems. These playbooks define the tasks to be executed on remote hosts, facilitating the automation of various system administration tasks.

## Files: 

1. **update-nodes.yaml**
This playbook updates and upgrades apt packages on all hosts specified in the inventory. It utilizes Ansible's apt module to perform the package management tasks.

## Setup Guide 
To install and set up Ansible, follow these steps: 

### Installation
1. For **Manjaro** or **Arch-based** systems:
    </br>
    Open a terminal and run: 
    ```bash
    sudo pacman -S ansible
    ```

2. Install `sshpass`:
    </br>
    If you plan to use the `-k` option when running Ansible commands to input a password, install `sshpass`:
    ```bash 
    sudo pacman -S sshpass
    ```

### Configuration
1. Create an Ansible Inventory File: 
    </br>
    Create a directory named `ansible` in the `$HOME` path. Than create a file named `hosts` with the following format: 
    ``` ini
    [k3s_master]
    master ansible_host=<ip_address>

    [k3s_workers]
    worker1 ansible_host=<ip_address>
    worker2 ansible_host=<ip_address>

    [all:vars]
    ansible_user=<username_used_for_nodes>
    ```
    _Replace `ip_address` with the actual IP addresses of your hosts._


## Testing Connectivity
To ensure that Ansible can communicate with the nodes, use the following command to test connectivity with the `ping` module: 
```bash
ansible -i ~/ansible/hosts all -m ping -k
```
This command will attempt to ping all hosts defined in your inventory file. If the setup is correct, you should see a success response from each host.

## Running the Playbooks 
To run the playbooks in the current Git repository, navigate to the folder containing the playbooks. The playbooks for Ansible are located under the `ansible-configs` folder. Use the following command to execute the desired playbook. </br>
For Example:
```bash 
ansible-playbook -i ~/ansible/hosts ansible-configs/update-nodes-new.yaml -k
```
Ensure the inventory file is correctly configured before running the playbook.

## Contributing: 

Feel free to contribute additional playbooks or improvements to existing ones to enhance the automation capabilities of this repository.

