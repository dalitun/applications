Rundeck in Docker
=================

Rundeck with Ansible

Docker Compose
--------------

Require MySQL for work

```yml
---
rundeck_db:
  image: mysql:5.7.10
  restart: always
  container_name: rundeck_db
  volumes:
    - /mnt/docker/mysql:/var/lib/mysql
  environment:
    - MYSQL_USER=rundeck
    - MYSQL_PASSWORD=SeCrEt
    - MYSQL_DATABASE=rundeck

rundeck:
  image: pavelgopanenko/rundeck:2.6.2
  restart: always
  container_name: rundeck
  ports:
    - "80:4440"
  volumes:
   - /rundeck/keys:/rundeck/var/storage/content/keys
   - /rundeck/projects:/rundeck/projects
  links:
   - rundeck_db:mysql
  environment:
    - RUNDECK_SERVER_NAME=rundeck
    - RUNDECK_WEB_CONTEXT=/
    - RUNDECK_USER_NAME=admin
    - RUNDECK_USER_PASSWORD=admin
    - RUNDECK_SERVER_URL=http://localhost
    - RUNDECK_DB_USERNAME=rundeck
    - RUNDECK_DB_PASSWORD=SeCrEt
    - RUNDECK_DB_HOST=mysql
    - RUNDECK_DB_PORT=3306
```

