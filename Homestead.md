# Homestead

How to customize Homestead.

- [Homestead](https://laravel.com/docs/6.x/homestead)
- [Laravel 6](https://laravel.com/docs/6.x)

## Installation

In host terminal:

```bash
mkdir -p ~/vm && cd $_
vagrant box add laravel/homestead
git clone https://github.com/laravel/homestead.git
cd ~/vm/homestead
git checkout release
bash init.sh
```

## Configuration

Look at:

- `Vagrantfile`
- `aliases`
- `scripts/homestead.rb`
- `scripts/features/docker.sh`
- `scripts/features/mariadb.sh`
- `scripts/site-types/apache.sh`

### Create Homestead.yaml

Look at `Homestead.yaml`

## Patches

### Turn off VirtualBox Guest Additions auto update

```bash
cd ~/Work/Code/bcit/homestead
mkdir -p ~/Work/Code/bcit/homestead/patches
# Backup original
cp ./Vagrantfile ./patches/Vagrantfile
# Edit & save `./patches/Vagrantfile`
# Create diff
diff ./Vagrantfile ./patches/Vagrantfile > ./patches/Vagrantfile.diff
cat ./patches/Vagrantfile.diff
# Patch
patch -p0 ./Vagrantfile < ./patches/Vagrantfile.diff
# Delete backup
rm ./patches/Vagrantfile
```

If needed:

```bash
# Revert
patch -R -p0 ./Vagrantfile < ./patches/Vagrantfile.diff
```

`patches/Vagrantfile.diff`

```diff
56a57,60
> 
>     if Vagrant.has_plugin?('vagrant-vbguest')
>         config.vbguest.auto_update = false
>     end
```

### Make MariaDB root no password

```bash
cd ~/Work/Code/bcit/homestead
mkdir -p ~/Work/Code/bcit/homestead/patches
# Backup original
cp ./scripts/features/mariadb.sh ./patches/mariadb.sh
# Edit & save `./patches/mariadb.sh`
# Create diff
diff ./scripts/features/mariadb.sh ./patches/mariadb.sh > ./patches/mariadb.sh.diff
cat ./patches/mariadb.sh.diff
# Patch
patch -p0 ./scripts/features/mariadb.sh < ./patches/mariadb.sh.diff
# Delete backup
rm ./patches/mariadb.sh
```

If needed:

```bash
# Revert
patch -R -p0 ./scripts/features/mariadb.sh < ./patches/mariadb.sh.diff
```

`patches/mariadb.sh.diff`

```diff
42,43d41
< debconf-set-selections <<< "mariadb-server mysql-server/root_password password secret"
< debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password secret"
58c56
< mysql --user="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
---
> mysql --user="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' WITH GRANT OPTION;"
61,63c59,61
< mysql --user="root" -e "CREATE USER IF NOT EXISTS 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
< mysql --user="root" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
< mysql --user="root" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
---
> mysql --user="root" -e "CREATE USER IF NOT EXISTS 'docx-to-html'@'0.0.0.0' IDENTIFIED BY 'secret';"
> mysql --user="root" -e "GRANT ALL ON *.* TO 'docx-to-html'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
> mysql --user="root" -e "GRANT ALL ON *.* TO 'docx-to-html'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
```

### Add `ll` alias

```bash
cd ~/Work/Code/bcit/homestead
mkdir -p ~/Work/Code/bcit/homestead/patches
# Backup original
cp ./aliases ./patches/aliases
# Edit & save `./patches/aliases`
# Create diff
diff ./aliases ./patches/aliases > ./patches/aliases.diff
cat ./patches/aliases.diff
# Patch
patch -p0 ./aliases < ./patches/aliases.diff
# Delete backup
rm ./patches/aliases
```

If needed:

```bash
# Revert
patch -R -p0 ./aliases < ./patches/aliases.diff
```

`patches/aliases.diff`

```diff
0a1
> alias ll="ls -lAFh"
```

### Add custom bash provisioning commands

```bash
cd ~/Work/Code/bcit/homestead
mkdir -p ~/Work/Code/bcit/homestead/patches
# Backup original
touch ./user-customizations.sh
echo '# Custom bash provisioning commands
sudo timedatectl set-timezone Canada/Pacific
echo "Time zone: " $(cat /etc/timezone)
sudo apt-get -y install tree zip
' | tee ./patches/user-customizations.sh
# Create diff
diff ./user-customizations.sh ./patches/user-customizations.sh > ./patches/user-customizations.sh.diff
cat ./patches/user-customizations.sh.diff
# Patch
patch -p0 ./user-customizations.sh < ./patches/user-customizations.sh.diff
# Delete backup
rm ./patches/user-customizations.sh
```

If needed:

```bash
# Revert
patch -R -p0 ./user-customizations.sh < ./patches/user-customizations.sh.diff
```

`patches/user-customizations.sh.diff`

```diff
0a1,5
> # Custom bash provisioning commands
> sudo timedatectl set-timezone Canada/Pacific
> echo "Time zone: " $(cat /etc/timezone)
> sudo apt-get -y install tree zip
```

## Provision

In host terminal:

```bash
cd ~/vm/homestead
vagrant up --provision
vagrant ssh
```

## Checks

### Check MariaDB root no password

In guest terminal:

```bash
mysql -u root
MariaDB [(none)]> SHOW DATABASES; quit;
```

### Check Apache configuration

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
```

---
