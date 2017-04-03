# Monitoring configuration Monit
https://mmonit.com/monit/

## Installation
```sh
sudo apt-get install monit
```

## Configuration

#### Services monitored and manage services from a web interface

```sh
sudo vim /etc/monit/monitrc
```

```sh
 set httpd port 2812 and
#    use address localhost  # only accept connection from localhost
#    allow localhost        # allow localhost to connect to the server and
    allow admin:monit      # require user 'admin' with password 'monit'
#    allow @monit           # allow users of group 'monit' to connect (rw)
#    allow @users readonly  # allow users of group 'users' to connect readonly
```

#### Monitoring services

```sh
sudo vim /etc/monit/cond.d/project_name
```

```sh
# /etc/monit/cond.d/project_name
### Nginx ###
check process nginx
  with pidfile /opt/nginx/logs/nginx.pid
  start program = "/etc/init.d/nginx start"
  stop program = "/etc/init.d/nginx stop"
  if cpu > 60% for 2 cycles then alert
  if cpu > 80% for 5 cycles then restart
  if memory usage > 80% for 5 cycles then restart
  if failed host 127.0.0.1 port 80 protocol http
    then restart
  if 3 restarts within 5 cycles then timeout

### Unicorn ###
check process unicorn
  with pidfile "/home/deployer/project_name/shared/tmp/pids/unicorn.pid"
  start program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && RAILS_ENV=production /home/deployer/.rvm/bin/rvm default do bundle exec unicorn -c /home/deployer/project_name/current/config/unicorn/production.rb -E deployment -D'"
  stop program = "/bin/su - deployer -c 'kill -s TERM `cat /home/deployer/project_name/current/tmp/pids/unicorn.pid`'"
  if memory usage > 70% for 2 cycles then alert
  if memory usage > 90% for 3 cycles then restart
  if cpu > 70% for 1 cycles then alert
  if cpu > 90% for 2 cycles then restart
  if 5 restarts within 5 cycles then timeout

### Postgresql ###
check process postgresql
  with pidfile "/var/run/postgresql/9.3-main.pid"
  start program = "/usr/sbin/service postgresql start"
  stop  program = "/usr/sbin/service postgresql stop"
  if failed host localhost port 5432 protocol pgsql then restart
  if cpu > 80% for 5 cycles then restart
  if memory usage > 80% for 2 cycles then restart
  if 5 restarts within 5 cycles then timeout

### Redis ###
check process redis-server
    with pidfile "/var/run/redis/redis-server.pid"
    start program = "/etc/init.d/redis-server start"
    stop program = "/etc/init.d/redis-server stop"
    if totalmem > 100 Mb then alert
    if children > 255 for 5 cycles then stop
    if cpu usage > 95% for 3 cycles then restart
    if memory usage > 80% for 5 cycles then restart
    if failed host 127.0.0.1 port 6379 then restart
    if 5 restarts within 5 cycles then timeout

### Sidekiq ###
check process sidekiq
  with pidfile "/home/deployer/project_name/shared/tmp/pids/sidekiq.pid"
  start program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && /home/deployer/.rvm/bin/rvm default do bundle exec sidekiq --index 0 --pidfile /home/deployer/project_name/shared/tmp/pids/sidekiq.pid --environment production --logfile /home/deployer/project_name/shared/log/sidekiq.log --daemon'"
  stop program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && /home/deployer/.rvm/bin/rvm default do bundle exec sidekiqctl stop /home/deployer/project_name/shared/tmp/pids/sidekiq.pid 10'"
  if cpu > 80% then restart
  if memory usage > 80% for 2 cycles then restart
  if 3 restarts within 3 cycles then timeout

### Sphinx ###
check process sphinx
  with pidfile "/home/deployer/project_name/shared/log/production.sphinx.pid"
  start program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && /home/deployer/.rvm/bin/rvm default do bundle exec rake RAILS_ENV=production ts:start'"
  stop program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && /home/deployer/.rvm/bin/rvm default do bundle exec rake RAILS_ENV=production ts:stop'"
  if cpu > 80% then restart
  if memory usage > 80% for 2 cycles then restart
  if 3 restarts within 3 cycles then timeout

### Thin (private_pub) ###
check process thin
  with pidfile "/home/deployer/project_name/shared/tmp/pids/thin.pid"
  start program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && RAILS_ENV=production /home/deployer/.rvm/bin/rvm default do bundle exec thin -C config/private_pub_thin.yml start'"
  stop program = "/bin/su - deployer -c 'cd /home/deployer/project_name/current && RAILS_ENV=production /home/deployer/.rvm/bin/rvm default do bundle exec thin -C config/private_pub_thin.yml stop'"
  if cpu > 80% then restart
  if memory usage > 80% for 2 cycles then restart
  if 3 restarts within 3 cycles then timeout
```
