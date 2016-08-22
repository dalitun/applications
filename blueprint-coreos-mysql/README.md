# 5 Minutes Stacks, épisode 25 : MySQL #

## Episode 25 : MySQL

![mysql](img/MySQL.svg)

MySQL est un système de gestion de base de données ( SGBD ). Issu du monde libre, il est l'un des logiciels de gestion de base de données le plus utilisé au monde.

Mysql est un serveur de base de données relationnelles SQL, il est multi-thread ( peut exécuter plusieurs processus en même temps ) et multi-utilisateur qui fonctionne aussi bien sur Windows que sur Linux ou Mac OS. Les bases de données sont accessibles en utilisant de nombreux languages serveur, dont PHP, que nous utiliserons comme exemple.
## Preparations

### Les versions
  - CoreOS Stable 899.13.0
  - Docker 1.10.3
  - MySQL 5.6

### Les pré-requis pour déployer cette stack

Ceci devrait être une routine à présent:
 * Un accès internet
 * Un shell linux
 * Un [compte Cloudwatt](https://www.cloudwatt.com/cockpit/#/create-contact) avec une [ paire de clés existante](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * Les outils [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
 * Un clone local du dépôt git [Cloudwatt applications](https://github.com/cloudwatt/applications)

### Taille de l'instance
Par défaut, le script propose un déploiement sur une instance de type "standard-1" (n1.cw.standard-1). Il existe une variété d'autres types d'instances pour la satisfaction de vos multiples besoins. Les instances sont facturées à la minute, vous permettant de payer uniquement pour les services que vous avez consommés et plafonnées à leur prix mensuel (vous trouverez plus de détails sur la [Page tarifs](https://www.cloudwatt.com/fr/produits/tarifs.html) du site de Cloudwatt).

Vous pouvez ajuster les parametres de la stack à votre goût.

### Au fait...

Si vous n’aimez pas les lignes de commande, vous pouvez passer directement à la version ["Je lance avec la console"](#console)...

## Tour du propriétaire

Une fois le dépôt cloné, vous trouverez le répertoire `blueprint-coreos-mysql/`

* `blueprint-coreos-mysql.heat.yml`: Template d'orchestration HEAT, qui servira à déployer l'infrastructure nécessaire.

* `stack-start.sh`: Script de lancement de la stack, qui simplifie la saisie des parametres et sécurise la création du mot de passe admin.

## Démarrage

### Initialiser l'environnement

Munissez-vous de vos identifiants Cloudwatt, et cliquez [ICI](https://console.cloudwatt.com/project/access_and_security/api_access/openrc/).
Si vous n'êtes pas connecté, vous passerez par l'écran d'authentification, puis le téléchargement d'un script démarrera. C'est grâce à celui-ci que vous pourrez initialiser les accès shell aux API Cloudwatt.

Sourcez le fichier téléchargé dans votre shell et entrez votre mot de passe lorsque vous êtes invité à utiliser les clients OpenStack.

 ~~~ bash
 $ source COMPUTE-[...]-openrc.sh
 Please enter your OpenStack Password:

 ~~~

Une fois ceci fait, les outils de ligne de commande d'OpenStack peuvent interagir avec votre compte Cloudwatt.

### Ajuster les paramètres

Dans le fichier `blueprint-coreos-mysql.heat.yml` vous trouverez en haut une section `parameters`. Le seul paramètre obligatoire à ajuster est celui nommé `keypair_name` dont la valeur `default` doit contenir le nom d'une paire de clés valide dans votre compte utilisateur.
C'est dans ce même fichier que vous pouvez ajuster la taille de l'instance par le paramètre `flavor`.

~~~ yaml
heat_template_version: 2013-05-23
description: Blueprint CoreOS Mysql
parameters:
  keypair_name:
    description: Keypair to inject in instance
    label: SSH Keypair
    type: string

  flavor_name:
    default: n1.cw.standard-1
    description: Flavor to use for the deployed instance
    type: string
    label: Instance Type (Flavor)
    constraints:
      - allowed_values:
          - n1.cw.standard-1
          - n1.cw.standard-2
          - n1.cw.standard-4
          - n1.cw.standard-8
          - n1.cw.standard-12
          - n1.cw.standard-16

  sqlpass:
    description: password root sql
    label: Mysql password
    type: string
    hidden: true


  volume_size:
    default: 5
    label: Backup Volume Size
    description: Size of Volume for mysql Storage (Gigabytes)
    type: number
    constraints:
      - range: { min: 5, max: 10000 }
        description: Volume must be at least 10 gigabytes

  volume_type:
    default: standard
    label: Backup Volume Type
    description: Performance flavor of the linked Volume for mysql Storage
    type: string
    constraints:
      - allowed_values:
          - standard
          - performant
 [...]
 ~~~
### Démarrer la stack

 Dans un shell, lancer le script `stack-start.sh` :

 ~~~ bash
 $ ./stack-start.sh mysql
 +--------------------------------------+------------+--------------------+----------------------+
 | id                                   | stack_name | stack_status       | creation_time        |
 +--------------------------------------+------------+--------------------+----------------------+
 | xixixx-xixxi-ixixi-xiixxxi-ixxxixixi | mysql     | CREATE_IN_PROGRESS | 2025-10-23T07:27:69Z |
 +--------------------------------------+------------+--------------------+----------------------+
 ~~~

 Attendez **5 minutes** que le déploiement soit complet (vous pouvez utiliser la commande `watch` pour voir le statut en temps réel).

 ~~~ bash
 $ watch -n 1 heat stack-list
 +--------------------------------------+------------+-----------------+----------------------+
 | id                                   | stack_name | stack_status    | creation_time        |
 +--------------------------------------+------------+-----------------+----------------------+
 | xixixx-xixxi-ixixi-xiixxxi-ixxxixixi | mysql     | CREATE_COMPLETE | 2025-10-23T07:27:69Z |
 +--------------------------------------+------------+-----------------+----------------------+
 ~~~

### Enjoy

 Une fois tout ceci fait, vous pouvez récupérer la description du votre stack à partir de cette commande :

 ~~~ bash
 $ heat stack-show mysql
 +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------+
 | Property              | Value                                                                                                                                |
 +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------+
 | capabilities          | []                                                                                                                                   |
 | creation_time         | 2016-08-22T15:59:21Z                                                                                                                 |
 | description           | Blueprint CoreOS Mysql                                                                                                               |
 | disable_rollback      | True                                                                                                                                 |
 | id                    | 505f01d0-1390-4cbf-869e-21aa6b031e8e                                                                                                 |
 | links                 | https://orchestration.fr1.cloudwatt.com/v1/467b00f998064f1688feeca95bdc7a88/stacks/mysql/505f01d0-1390-4cbf-869e-21aa6b031e8e (self) |
 | notification_topics   | []                                                                                                                                   |
 | outputs               | [                                                                                                                                    |
 |                       |   {                                                                                                                                  |
 |                       |     "output_value": "mysql://floating_ip:3306",                                                                                      |
 |                       |     "description": "Mysql uri",                                                                                                      |
 |                       |     "output_key": "floating_ip_url"                                                                                                  |
 |                       |   }                                                                                                                                  |
 |                       | ]                                                                                                                                    |
 | parameters            | {                                                                                                                                    |
 |                       |   "sqlpass": "******",                                                                                                               |
 |                       |   "OS::project_id": "467b00f998064f1688feeca95bdc7a88",                                                                              |
 |                       |   "OS::stack_id": "505f01d0-1390-4cbf-869e-21aa6b031e8e",                                                                            |
 |                       |   "OS::stack_name": "mysql",                                                                                                         |
 |                       |   "keypair_name": "alikey",                                                                                                          |
 |                       |   "volume_type": "standard",                                                                                                         |
 |                       |   "volume_size": "5",                                                                                                                |
 |                       |   "flavor_name": "n1.cw.standard-1"                                                                                                  |
 |                       | }                                                                                                                                    |
 | parent                | None                                                                                                                                 |
 | stack_name            | mysql                                                                                                                                |
 | stack_owner           | youremail@cloudwatt.com                                                                                            |
 | stack_status          | CREATE_COMPLETE                                                                                                                      |
 | stack_status_reason   | Stack CREATE completed successfully                                                                                                  |
 | stack_user_project_id | 4a64954892f048e592d7c15fe292cdb9                                                                                                     |
 | template_description  | Blueprint CoreOS Mysql                                                                                                               |
 | timeout_mins          | 60                                                                                                                                   |
 | updated_time          | None                                                                                                                                 |
 +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------+
 ~~~


 Vous pouvez vous connecter sur le serveur MySQL à partir d'un client MySQL.

 ~~~ bash
 sudo apt-get -y install  mysql-client
 mysql -h flottingIp -u root -psqlpass
 ~~~

##### Systemd - système d'initialisation de service MySQL

Pour démarrer le service :
~~~ bash
sudo systemctl start mysql.service
~~~

Il est possible de consulter les logs en sortie du service lancé grâce à la commande suivante :
~~~ bash
journalctl -f -u mysql.service
~~~

Le service se stop de la manière suivante :
~~~ bash
sudo systemctl stop mysql.service
~~~

#### Autres sources pouvant vous intéresser:

* [CoreOS homepage](https://coreos.com/)
* [Docker Documentation](https://docs.docker.com/)
* [MySQL Documentatuion](https://www.mysql.com/)

-----
Have fun. Hack in peace.
