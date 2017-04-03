# Server configuration for project

```sh
sudo apt-get update
sudo apt-get upgrade
sudo dpkg-reconfigure tzdata
sudo reboot
```

## User

```sh
root:$ adduser deployer
root:$ visudo
```

Change ssh port
```sh
sudo apt-get install vim
vim /etc/ssh/sshd_config
```
```bash
# What ports, IPs and protocols we listen for
Port 22
```
```sh
reload ssh
mkdir ~/.ssh
```
Add developer authorized_keys
```sh
dev:~$ cat ~/.ssh/id_rsa.pub | ssh deployer@SERVER_IP -p SERVER_SSH_PORT 'cat >> /home/deployer/.ssh/authorized_keys'
```

```sh
sudo apt-get install git-core
```

## Ruby

```sh
sudo apt-get install curl
curl -L get.rvm.io | bash -s stable
source /home/deployer/.rvm/scripts/rvm
rvm requirements
rvm install 2.3
rvm use 2.3 --default
ruby -v
```

## Postgres

```sh
sudo apt-get install postgresql postgresql-contrib postgresql-server-dev-9.3
sudo -u postgres psql
postgres=# alter user postgres with password 'DB_PASSWORD';
```

login in database

```sh
sudo vim /etc/postgresql/9.3/main/pg_hba.conf
```

```sh
# /etc/postgresql/9.3/main/pg_hba.conf
# Database administrative login by Unix domain socket
local   all             postgres                                peer
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
```

replaced by:
```sh
# Database administrative login by Unix domain socket
local   all             postgres                                md5
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
local   all             all                                     md5
```

```sh
sudo service postgresql restart
sudo -u postgres psql
CREATE DATABASE DB_PROJECT_production;
```

## Nginx

```sh
gem install passenger

sudo apt-get install libcurl4-openssl-dev
rvmsudo passenger-install-nginx-module
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap
rvmsudo passenger-install-nginx-module
```

```sh
sudo vim /opt/nginx/conf/nginx.conf
```
[nginx config passenger](nginx_conf_passenger.md)
[nginx config unicorn](nginx_conf_unicorn.md)

Nginx init script
git clone https://github.com/vkurennov/rails-nginx-passenger-ubuntu.git

```sh
sudo cp rails-nginx-passenger-ubuntu/nginx/nginx /etc/init.d/
sudo chmod +x /etc/init.d/nginx
sudo /etc/init.d/nginx start
```

## Redis

```sh
sudo apt-get install redis-server
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.default
sudo service redis-server restart
```

## Shpinx

```sh
sudo apt-get install libmysqlclient-dev
sudo apt-get install sphinxsearch
```

## Mail server

```sh
sudo apt-get install exim4-daemon-light mailutils
sudo dpkg-reconfigure exim4-config
```
Sending a test message
```sh
echo "This is a test" | mail -s testing YOUR@email.com
```

## Monitoring
[Monitoring configuration Monit](monit_config.md)

## Backup
[backup ](backup.md)
