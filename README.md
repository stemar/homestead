# Homestead

Make a Vagrant box with Ubuntu 18.04 LAMP stack. Add patches for customizations.

- Host: Linux or Mac.

## Summary

In host terminal:

```bash
mkdir -p ~/vm && cd $_
git clone https://github.com/stemar/homestead.git
cd ~/vm/homestead
vagrant up --provision
vagrant ssh
```

## Goals

- Add `ll` alias.
- Use MariaDB without a password for username `root`.
- Don't update VirtualBox Guest Additions if `vagrant-vbguest` plugin is installed.
- Add `user-customizations.sh`

## Prerequisites

### Vagrant and Oracle VM VirtualBox installed

- [VirtualBox 6.0.10](https://www.virtualbox.org/wiki/Downloads)
- [VirtualBox 6.0.10 Extension Pack](https://www.virtualbox.org/wiki/Downloads)
- [VirtualBox Guest Additions](https://www.virtualbox.org/manual/ch04.html#additions-linux)
- [Vagrant 2.2.5](https://www.vagrantup.com/downloads.html)

Look at all VirtualBox downloads [here](https://download.virtualbox.org/virtualbox)

### Create Homestead.yaml

Read the [documentation](https://laravel.com/docs/homestead) and
look at this repository's `Homestead.yaml` for example.

## Start here

In host terminal:

```bash
mkdir -p ~/vm && cd $_
git clone https://github.com/stemar/homestead.git
```

> You can have more than one vagrant dirtree under the `~/vm` directory.  
> Ex.: `git clone https://github.com/stemar/vagrant-centos-7-6.git centos-7-6`

### Separate VMs dirtree

Vagrant supports the definition of [multiple VMs](https://www.vagrantup.com/docs/multi-machine) inside one `Vagrantfile`,
but if I separate my VMs by LAMP stack in a dirtree, I can run, maintain and troubleshoot them independently.

- I can have a smaller, focused `Vagrantfile` for each VM.
- I can have LAMP-specific `config` files to help the provision file.
- `.vagrant` is created independently within each VM directory.
- I can open separate tabs in my terminal, `cd` into separate VM dirtrees and `vagrant up`/`vagrant halt`
  without having to write the machine name: `vagrant up ubuntu-18-04`/`vagrant halt ubuntu-18-04`
- `vagrant global-status` still works as intended to see all VMs on the host machine.
- I change the HTTP and MySQL ports in `Vagrantfile` to avoid collisions and Vagrant errors at provisioning.

### Boot Homestead

In host terminal:

```bash
cd ~/vm/homestead
vagrant up --provision
```

### If something goes wrong

In host terminal:

```bash
vagrant halt -f
OR
vagrant destroy -f
AND
vagrant up --provision
```

## Log in homestead

In host terminal:

```bash
vagrant ssh
```

### Prompt inside homestead

In guest terminal:

```console
vagrant@homestead:~$
```

## Checks

### Check MariaDB root no password

In guest terminal:

```bash
mysql -u root
MariaDB [(none)]> SHOW DATABASES; quit;
```

### Check Apache

In guest terminal:

```bash
cat /etc/hosts
cat /etc/apache2/apache2.conf
cat /etc/apache2/envvars
ll /etc/apache2/conf-available
ll /etc/apache2/conf-enabled
ll /etc/apache2/sites-available
ll /etc/apache2/sites-enabled
apachectl -V
apachectl configtest
curl -I localhost
```

Result:

```http
HTTP/1.1 200 OK
...
```

In host browser:

```input
http://localhost:8002
```

You see the "Apache2 Ubuntu Default Page".

### Check your domain

Ex.: Replace `example.com` with your domain and the port number with your custom redirect number.

In host browser:

```input
http://example.com.localhost:8002
```

You see the home page.

---

## References

- Vagrant: <https://www.vagrantup.com>
- Vagrant troubleshooting: <https://www.mediawiki.org/wiki/MediaWiki-Vagrant#Troubleshooting_startup>
- Oracle VirtualBox: <https://www.virtualbox.org/wiki/Downloads>
- Oracle VirtualBox Guest Additions: <https://www.virtualbox.org/manual/ch04.html>
- Ubuntu: <https://www.ubuntu.com>
- Homestead: <https://laravel.com/docs/homestead>
