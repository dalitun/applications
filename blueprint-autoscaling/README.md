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

### Comment créer configurer zabbix pour qu'il fasse l'autoscaling

Il faut passer par les étapes suivantes:

#### 1) Installer votre MycloudManager

Cliquez sur ce [lien] (https://github.com/cloudwatt/applications/blob/master/application-mycloudmanager-v2/README.md)

#### 2) Lancer stack exemple autoscaling


#### 3) Ajouter les noeuds à Zabbix de MycloudManager

#### 4) Mise à jour le template OS Linux Zabbix


#### 5) Créer les Actions scale up et scale download


N'oublie pas de ajouter chaque nouveau scalé à zabbix dans le Host Groupe de votre stack







-----
Have fun. Hack in peace.

The CAT
