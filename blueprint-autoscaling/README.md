# Autoscaling via zabbix MyCloudManager:

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

### Comment configurer zabbix de MycloudManager pour qu'il fasse le autoscaling

Il faut passer par les étapes suivantes:

#### 1) Comment déployer MycloudManager.

Cliquez sur ce [lien] (https://github.com/cloudwatt/applications/blob/master/application-mycloudmanager-v2/README.md "Installer MyCloudManager")

#### 2) Lancer stack exemple autoscaling

avant de lancer la stack ajouter l'autorisation du port 30000 pour le réseau de la stack pour mcm
On a crée une petite template autoscaling:

~~~bash
heat stack-create nom_stack -f autoscaling.yaml --parameters="InstanceType=m1.small;DBUsername=dbuser;DBPassword=verybadpassword;DBRootPassword=anotherverybadpassword;KeyName=nectar_dev"
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
