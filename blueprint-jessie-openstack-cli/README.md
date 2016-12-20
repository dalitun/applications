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


### Au fait...

Si vous n’aimez pas les lignes de commande, vous pouvez passer directement à la version ["Je lance avec la console"](#console)...

## Tour du propriétaire

Une fois le dépôt cloné, vous trouverez le répertoire `blueprint-jessie-openstack-cli/`

* `blueprint-jessie-openstack-cli.heat.yml`: Template d'orchestration HEAT, qui servira à déployer l'infrastructure nécessaire.

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

Dans le fichier `blueprint-jessie-openstack-cli.heat.yml` vous trouverez en haut une section `parameters`.

~~~ yaml
  heat_template_version: 2013-05-23

  description: Template help you to start in your tenant.

  parameters:
    keypair_name:
      description: Keypair to inject in instances
      type: string

    flavor_name:
      default: t1.cw.tiny
      label: Instance Type (Flavor)
      description: Flavor to use for the deployed instance
      type: string
      constraints:
        - allowed_values:
          - t1.cw.tiny
          - s1.cw.small-1
          - n1.cw.standard-1
          - n1.cw.standard-2
          - n1.cw.standard-4
          - n1.cw.standard-8
          - n1.cw.standard-12
          - n1.cw.standard-16

    os_username:
      description: OpenStack Username
      label: OpenStack Username
      type: string

    os_password:
      description: OpenStack Password
      label: OpenStack Password
      type: string
      hidden: true

    os_tenant_name:
      description: OpenStack Tenant Name
      label: OpenStack Tenant Name
      type: string

    os_auth_url:
      description: OpenStack Auth URL
      default: https://identity.fr1.cloudwatt.com/v2.0
      label: OpenStack Auth URL
      type: string

    network_name:
      description: network name
      label: network name
      type: string
~~~
### Démarrer la stack

Dans un shell,lancer le script la commande suivante :

~~~
heat stack-create nom_de_votre_stack -f blueprint-jessie-openstack-cli.heat.yml
~~~

Exemple :

~~~bash
$ heat stack-create mysatck_name -f blueprint-jessie-openstack-cli.heat.yaml
+--------------------------------------+-----------------+--------------------+----------------------+
| id                                   | stack_name      | stack_status       | creation_time        |
+--------------------------------------+-----------------+--------------------+----------------------+
| ee873a3a-a306-4127-8647-4bc80469cec4 | nom_de_votre_stack       | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
+--------------------------------------+-----------------+--------------------+----------------------+
~~~

Puis attendez quelques minutes que le déploiement soit complet.

~~~bash
$ heat resource-list nom_de_votre_stack
+---------------+--------------------------------------+----------------------------+-----------------+----------------------+
| resource_name | physical_resource_id                 | resource_type              | resource_status | updated_time         |
+---------------+--------------------------------------+----------------------------+-----------------+----------------------+
| keypair       | JeStart-mykeypair                    | OS::Nova::KeyPair          | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
| network       | 165fff85-a6ac-4bdd-ad63-ac2ba8e58f45 | OS::Neutron::Net           | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
| sg            | 9d5f6961-8eb2-4e59-b637-fa3f70659b55 | OS::Neutron::SecurityGroup | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
| subnet        | f5d63c5e-1fb5-4ed9-9927-a7025c5dbd95 | OS::Neutron::Subnet        | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
+---------------+--------------------------------------+----------------------------+-----------------+----------------------+
~~~

## C’est bien tout ça,
### mais vous n’auriez pas un moyen de lancer l’application par la console ?

Et bien si ! En utilisant la console, vous pouvez déployer un serveur mail:

1.	Allez sur le Github Cloudwatt dans le répertoire [applications/Jestart](https://github.com/cloudwatt/applications/tree/master/blueprint-jessie-openstack-cli)
2.	Cliquez sur le fichier nommé `blueprint-jessie-openstack-cli.heat.yml`
3.	Cliquez sur RAW, une page web apparait avec le détail du script
4.	Enregistrez-sous le contenu sur votre PC dans un fichier avec le nom proposé par votre navigateur (enlever le .txt à la fin)
5.  Rendez-vous à la section « [Stacks](https://console.cloudwatt.com/project/stacks/) » de la console.
6.	Cliquez sur « Lancer la stack », puis cliquez sur « fichier du modèle » et sélectionnez le fichier que vous venez de sauvegarder sur votre PC, puis cliquez sur « SUIVANT »
7.	Donnez un nom à votre stack dans le champ « Nom de la stack »
8.	Remplissez les deux champs  « key Name prefix » et « /24 cidr of private network » puis cliquez sur « LANCER »

La stack va se créer automatiquement (vous pouvez en voir la progression cliquant sur son nom). Quand tous les modules deviendront « verts », la création sera terminée.
C’est (déjà) FINI !

### Vous n’auriez pas un moyen de lancer l’application en 1-clic ?

Bon... en fait oui ! Allez sur la page [Applications](https://www.cloudwatt.com/fr/applications/index.html) du site de Cloudwatt, choisissez l'appli, appuyez sur **DEPLOYER** et laisser vous guider... 2 minutes plus tard un bouton vert apparait... **ACCEDER** : vous avez votre Stack !


## Enjoy
quelques usage de la commande `openstack`

Pour lister instances qui sont créées sur votre tanant :
~~~bash
$ openstack server list
~~~  

Pour lister les images qui se trouvent dans votre tanant :
~~~bash
$ openstack image list
~~~  

Les variables d'environment sont dans le fichier `/home/cloud/.bashrc`.

### Autres sources pouvant vous intéresser:
* [ Openstack-cli page](http://docs.openstack.org/user-guide/cli-cheat-sheet.html)
----
Have fun. Hack in peace.
