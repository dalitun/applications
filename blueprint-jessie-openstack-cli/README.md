# 5 Minutes Stacks, épisode 25 : Blueprint-jessie-openstack-cli #

## Episode 25 : Blueprint-jessie-openstack-cli

Ce stack vous permet d'installer openstack client et configurer vos credentials pour accéder aux API Cloudwatt via le shell.


## Preparations

### Les pré-requis pour déployer cette stack
Ceci devrait être une routine à présent:

* Un accès internet
* Un shell linux
* Un [compte Cloudwatt](https://www.cloudwatt.com/cockpit/#/create-contact) avec une [ paire de clés existante](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
* Les outils [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
* Un clone local du dépôt git [Cloudwatt applications](https://github.com/cloudwatt/applications)

### Taille de l'instance

Par défaut, le script propose un déploiement sur une instance de type " Small " (s1.cw.tiny-1) en tarification à l'usage (les prix à l'heure et au mois sont disponibles sur la [page Tarifs](https://www.cloudwatt.com/fr/produits/tarifs.html) du site de Cloudwatt). Bien sûr, vous pouvez ajuster les paramètres de la stack et en particulier sa taille par défaut.

## Démarrage

### mais vous n’auriez pas un moyen de lancer l’application par la console ?

Et bien si ! En utilisant la console, vous pouvez déployer un serveur mail:

1.	Allez sur le Github Cloudwatt dans le répertoire [applications/blueprint-jessie-openstack-cli](https://github.com/cloudwatt/applications/tree/master/blueprint-jessie-openstack-cli)
2.	Cliquez sur le fichier nommé `blueprint-jessie-openstack-cli.heat.yml`
3.	Cliquez sur RAW, une page web apparait avec le détail du script
4.	Enregistrez-sous le contenu sur votre PC dans un fichier avec le nom proposé par votre navigateur (enlever le .txt à la fin)
5.  Rendez-vous à la section « [Stacks](https://console.cloudwatt.com/project/stacks/) » de la console.
6.	Cliquez sur « Lancer la stack », puis cliquez sur « fichier du modèle » et sélectionnez le fichier que vous venez de sauvegarder sur votre PC, puis cliquez sur « SUIVANT »
7.	Donnez un nom à votre stack dans le champ « Nom de la stack »
8.	Entrez votre keypair dans le champ « keypair_name »
9.	Choisissez la taille de votre instance parmi le menu déroulant « flavor_name » et cliquez sur « LANCER »
10. network_name Entrez votre keypair dans le champ « keypair_name »
11. os_auth_url Entrez votre keypair dans le champ « keypair_name »
12. os_region_name Entrez votre keypair dans le champ « keypair_name »
13. os_tenant_name Entrez votre keypair dans le champ « keypair_name »
14. os_username Entrez votre keypair dans le champ « keypair_name »
15. os_password Entrez votre keypair dans le champ « keypair_name »
La stack va se créer automatiquement (vous pouvez en voir la progression cliquant sur son nom). Quand tous les modules deviendront « verts », la création sera terminée.
C’est (déjà) FINI !

### Vous n’auriez pas un moyen de lancer l’application en 1-clic ?

Bon... en fait oui ! Allez sur la page [Applications](https://www.cloudwatt.com/fr/applications/index.html) du site de Cloudwatt, choisissez l'appli, appuyez sur **DEPLOYER** et laisser vous guider... 2 minutes plus tard un bouton vert apparait... **ACCEDER** : vous avez votre Stack !


## Enjoy

### Quelques usages de la commande `openstack`.

Vous avez un point d'entrée sur votre machine virtuelle en ssh via l'IP flottante exposée et votre clé privée (utilisateur `cloud` par défaut).

Pour lister les instances qui sont sur votre tanant :

~~~bash
$ openstack server list
~~~  

Pour lister les images qui sont sur votre tanant :
~~~bash
$ openstack image list
~~~  

Pour créer une stack via heat
~~~bash
$ openstack stack create --template server_console.yaml
~~~
Les variables d'environment sont dans le fichier `/home/cloud/.bashrc`.

### Autres sources pouvant vous intéresser:

* [ Openstack-cli page](http://docs.openstack.org/user-guide/cli-cheat-sheet.html)
----
Have fun. Hack in peace.
