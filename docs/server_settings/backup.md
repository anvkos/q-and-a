# Configuration backup
http://backup.github.io/backup/

## Installation

```sh
~$ gem install backup

```

## Configuration

```sh
~$ backup generate:model -t project_name_backup --databases='postgresql' --storages='local' --compressor='gzip'
```

```sh
~$ vim Backup/models/project_name_backup.rb
```

```ruby
# encoding: utf-8

##
# Backup Generated: project_name_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t project_name_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:project_name_backup, 'Description for project_name_backup') do
  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "db_production"
    db.username           = "postgres"
    db.password           = "db_password"
    db.host               = "localhost"
    db.port               = 5432
#    db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
#    db.skip_tables        = ["skip", "these", "tables"]
#    db.only_tables        = ["only", "these", "tables"]
    db.additional_options = ["-xc", "-E=utf8"]
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 5
    # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip
end
```

## Periodic backup

```sh
gem install whenever
```

```sh
~$
cd Backup/
mkdir config
wheneverize .
vim config/schedule.rb
```

```ruby
every 1.day, at: '4.30 am' do
  command 'backup perform -t project_name_backup'
end
```

```sh
whenever --update-crontab
```
