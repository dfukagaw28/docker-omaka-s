# Docker files for Omeka S

## Setup

1. Clone this repository

```
$ cd /home/docker/compose
$ git clone git@github.com:dfukagaw28/docker-omeka-s.git
$ cd docker-omeka-s
```

2. Create configuration files

```
$ mkdir -p /home/docker/secrets/omeka
$ cp mysql.env.sample /home/docker/secrets/omeka/mysql.env
$ vi /home/docker/secrets/omeka/mysql.env
MYSQL_ROOT_PASSWORD=omekapass
MYSQL_USER=omeka
MYSQL_PASSWORD=omekapass
MYSQL_DATABASE=omeka
```

```
$ cp phpmyadmin.env.sample /home/docker/secrets/omeka/phpmyadmin.env
$ vi /home/docker/secrets/omeka/phpmyadmin.env
PMA_ABSOLUTE_URI=https://www.example.com/pma/
```

```
$ cp .env.sample .env
$ vi .env
APP_TZ=Asia/Tokyo
APP_IPV4=10.0.0.10
APP_NETWORK=10.0.0.0/24
PMA_IPV4=10.0.0.11
```

```
$ cp database.ini.sample database.ini
$ vi database.ini
user     = "omeka"
password = "omekapass"
dbname   = "omeka"
host     = "db"
;port     =
;unix_socket =
;log_path =
```

3. Build & Start 

```
$ docker-compose pull    # (optional)
$ docker-compose build   # (optional)
$ docker-compose up -d
```
