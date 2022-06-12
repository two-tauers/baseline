# two-tauers / baseline

Baseline setup of raspberry pi's to prepare them for k3s installation using ansible.

This does not install k3s cluster - see [two-tauers/k3s-ansible](https://github.com/two-tauers/k3s-ansible) fork for that.

## What does it do?

There are 4 roles in this repo:

### passwordless

After you flash the SD cards and boot Ubuntu Server for the first time, it will prompt you to change the default pasword (ubuntu) of the default user (ubuntu).
If ansible cannot connect using the ssh key in the inventory, this role perform the action using `expect` package by changing the password to `dummy-password` temporarily. The new password is only used to create users with SSH access in the `users` role, after which the default user is disabled.

By default two users are created - one for ansible, one for personal access, each with it's own SSH key pair.
This role will also generate the keys if they don't exist.

### configure

Sets hostnames, timezone, switches off wifi and bluetooth, configures memsplit, enables fan control.
This can be changed by adding `roles/configure/vars/main.yaml` to override default values in `roles/configure/default/main.yaml`.
If any changes are made, the host is restarted.

### apt_upgrade

Runs `apt update && apt upgrade` on all hosts.
When run on a freshly installed OS, this step might take a while.
At the time of writing this there were 90+ upgradeable packages, which took 10+ minutes to complete.
If you have fan control as configured above, some fans might spin up if the CPUs reach 70 C.

## Prerequisites

* `ansible` - tested on 2.12.0, but should work on any 2+
    * [docs](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

* `sshpass` - tested on 1.09
    * this one is required for the first time setup (ansible requirements for password access)
    * [how-to](https://www.cyberciti.biz/faq/noninteractive-shell-script-ssh-password-provider/)

* At least one raspberry pi with a freshly flashed image of Ubuntu Server 20.04 (64-bit version)
    * [downloads page](https://www.raspberrypi.com/software/)

## Usage

1. Check [inventory.yaml](inventory.yaml) and ensure the values are correct for your setup:

    * `hosts`: list of hosts (see [ansible guidelines](https://github.com/ansible/ansible/blob/devel/examples/hosts.yaml) and the file in this repo)

    * `vars`:

        * `ansible_ssh_user`: which user should ansible authenticate as

        * `ansible_ssh_private_key_file`: path to the private key for SSH access

        * `timezone`: timezone to set, e.g. Europe/London, US/Pacific, Asia/Tokyo (run `timedatectl list-timezones` on the pi to get the full list)

        * `users`: list of users to create. By default it creates a user for ansible and for personal access, each with its own SSH key pair (those are created during the run if missing)

        * `mounts`: drives to mount on startup

2. Run `ansible-playbook site.yaml` and wait for it
