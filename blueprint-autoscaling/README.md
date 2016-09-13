# Autoscaling via zabbix de MyCloudManager:
 ![logo](img/images-2.jpg)
Auto-scaling, autoscaling également orthographié, est une caractéristique de service de cloud computing qui ajoute ou supprime les ressources calcul en fonction de l'utilisation réelle automatiquement. Mise à l'échelle automatique est parfois appelée élasticité automatique.

## Préparations

### Les versions
  - MyCloudManager v2
  - zabbix 3

### Les pré-requis

 * Un accès internet
 * Un shell linux
 * Un [compte Cloudwatt](https://www.cloudwatt.com/cockpit/#/create-contact) avec une [ paire de clés existante](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * Les outils [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
 * MycloudManager V2 [lien] (https://github.com/cloudwatt/applications/blob/master/application-mycloudmanager-v2/README.md)

### Comment avoir l'autoscaling via zabbix de MyCloudManager

#### 1) Lancer stack exemple autoscaling

##### Ajuster les paramètres

Clonez le repo
Dans le fichier `blueprint-autoscaling-exemple.heat.yml` vous trouverez en haut une section `parameters`.

~~~ yaml
heat_template_version: 2013-05-23
description: AutoScaling blueprint exemple
parameters:
  keypair_name:
    description: Keypair to inject in instance
    default: votrekey   <-- Indiquer ici votre paire de clés par défaut
    label: SSH Keypair
    type: string

  flavor_name:
    default: n2.cw.standard-1   <-- Indiquer ici la taille de l’instance par défaut
    description: Flavor to use for the deployed instance
    type: string
    label: Instance Type (Flavor)
    constraints:
      - allowed_values:
          - t1.cw.tiny
          - s1.cw.small-1
          - n2.cw.standard-1
          - n2.cw.standard-2
          - n2.cw.standard-4
          - n2.cw.standard-8
          - n2.cw.standard-16
          - n2.cw.highmem-2
          - n2.cw.highmem-4
          - n2.cw.highmem-8
          - n2.cw.highmem-12
  net_cidr:               <-- Indiquer ici la taille de l’instance par défaut
    default: 192.168.0.0/24
    description: /24 cidr of fronts network
    label: /24 cidr of fronts network
    type: string

  router:
    label: router
    type: string
    default: 602565c8-ee30-4697-8a75-044898f381eb    <-- Indiquer ici la taille de l’instance par défaut
  mcm_public_key:
    type: string
    label: mcm public key
    default: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3sBV85fs2QUTKo.....  <-- Indiquer ici la taille de l’instance par défaut
~~~

##### Démarrer la stack

Avant de lancer la stack ajouter l'autorisation du port 30000 pour le réseau de la stack pour mcm

~~~bash
nova secgroup-add-rule SECURITY_GROUP_MCM tcp 30000 30000 cid_net_autoscaling
~~~
Puis dans le shell lancer la commande suivante :

~~~
heat stack-create nom_de_votre_stack -f blueprint-autoscaling-exemple.heat.yml
~~~

Exemple :

~~~bash
$ heat stack-create mysatck_name -f blueprint-mystart.heat.yml -Pkeypair_name_prefix=préfix -Pnet_cidr=192.168.1.0/24
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
| keypair       | mystart-mykeypair                    | OS::Nova::KeyPair          | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
| network       | 165fff85-a6ac-4bdd-ad63-ac2ba8e58f45 | OS::Neutron::Net           | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
| sg            | 9d5f6961-8eb2-4e59-b637-fa3f70659b55 | OS::Neutron::SecurityGroup | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
| subnet        | f5d63c5e-1fb5-4ed9-9927-a7025c5dbd95 | OS::Neutron::Subnet        | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
+---------------+--------------------------------------+----------------------------+-----------------+----------------------+
~~~


#### 3) Ajouter les noeuds à Zabbix de MycloudManager

![mcm](img/images-2.jpg)

#### 4) Mise à jour le template OS Linux Zabbix
![template](img/images-2.jpg)

#### 5) Créer les Actions scale up et scale download

pour savoir url scaling up

~~~bash
openstack stack output show  -f json  autoscale scale_up_url | jq '.output_value' | sed -e 's/^"//'  -e 's/"$//'
~~~

pour savoir url scaling down

~~~bash
openstack stack output show  -f json  autoscale scale_dn_url | jq '.output_value' | sed -e 's/^"//'  -e 's/"$//'
~~~

N'oubliez pas de ajouter chaque nouveau scalé à zabbix dans le Host Groupe de votre stack




-----
Have fun. Hack in peace.

The CAT
