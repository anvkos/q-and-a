# Configuration Nginx with Passenger

install

```sh
sudo vim /opt/nginx/conf/nginx.conf
```

```sh
# /opt/nginx/conf/nginx.conf

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}

http {
    passenger_root /home/deployer/.rvm/gems/ruby-2.3.3/gems/passenger-5.1.2;
    passenger_ruby /home/deployer/.rvm/gems/ruby-2.3.3/wrappers/ruby;

    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    gzip  on;

    server {
        listen       80;
        server_name  domain_project_name;
        root /home/deployer/project_name/current/public;

        passenger_enabled on;

        client_max_body_size 20M;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location ^~ /assets/ {
            gzip_static on;
            expires max;
            add_header Cache-Control public;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```
