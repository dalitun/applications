# Autoscaling via zabbix MyCloudManager:

 ![logo](img/images-2.jpg)

Auto-scaling, also spelled autoscaling, is a cloud computing service feature that automatically adds or removes compute resources depending upon actual usage. Auto-scaling is sometimes referred to as automatic elasticity.

## Preparations

### The prerequisites

 * Internet access
 * A Linux shell
 * A [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact) with a [valid keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * The tools [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)


### How to get autoscaling via MyCloudManager's Zabbix

#### 1/ Lanch  exemple autoscaling stack

##### Adjust the parameters

 In the `blueprint-autoscaling-exemple.heat.yml` file (heat template), you will find a section named `parameters` near the top.

 ~~~ yaml
 heat_template_version: 2013-05-23
 description: AutoScaling blueprint exemple
 parameters:
   keypair_name:
     description: Keypair to inject in instance
     default: yourkey   <-- Indicate here your keypair  
     label: SSH Keypair
     type: string

   flavor_name:
     default: n2.cw.standard-1   <-- Indicate here flavor size
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
   net_cidr:                  
     default: 192.168.0.0/24   <-- Indicate here cidr net
     description: /24 cidr of fronts network
     label: /24 cidr of fronts network
     type: string

   router:
     label: router
     type: string
     default: 602565c8-ee30-4697-8a75-044898f381eb     <-- Indicate here MyCloudManager router id
   mcm_public_key:   
     type: string
     label: mcm public key
     default: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3sBV85fs2QUTKo.....  <-- Indicate here MyCloudManager public key
 ~~~

##### Start the stack

Before starting the stack, open port 30000 in MycloudManager security groupe for your instances can communicate with MyCloudManager, typing the following command.

 ~~~bash
 $ nova secgroup-add-rule SECURITY_GROUP_MCM tcp 30000 30000 cid_net_autoscaling
 ~~~

 In a shell, run the following command:

 ~~~bash
 $ heat stack-create your_stack_name -f blueprint-autoscaling-exemple.heat.yaml

 +--------------------------------------+-----------------+--------------------+----------------------+
 | id                                   | stack_name      | stack_status       | creation_time        |
 +--------------------------------------+-----------------+--------------------+----------------------+
 | ee873a3a-a306-4127-8647-4bc80469cec4 | your_stack_name       | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
 +--------------------------------------+-----------------+--------------------+----------------------+
 ~~~

 Wait a few minutes the stack will be fully operational.

 ~~~bash
 $ heat resource-list your_stack_name
 +-----------------------------+-------------------------------------------------------------------------------------+------------------------------+-----------------+----------------------+
 | resource_name               | physical_resource_id                                                                | resource_type                | resource_status | updated_time         |
 +-----------------------------+-------------------------------------------------------------------------------------+------------------------------+-----------------+----------------------+
 | asg                         | bde4a6ff-c684-4458-82fe-358337ff43bb                                                | OS::Heat::AutoScalingGroup   | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | interface                   | 602565c8-ee30-4697-8a75-044898f381eb:subnet_id=ad09494b-7d90-4c80-8528-1e4c28df598b | OS::Neutron::RouterInterface | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | lb                          |                                                                                     | OS::Neutron::LoadBalancer    | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | lb_floating                 | b73ebb6f-b89f-4325-90d0-f68592c2a978                                                | OS::Neutron::FloatingIP      | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | net                         | 616c6ae1-1968-40cd-9164-c11f1ee5accd                                                | OS::Neutron::Net             | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | pool                        | 93199df3-1e06-4083-bdd1-c2a8d341add8                                                | OS::Neutron::Pool            | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | sec_group                   | 13d91e55-5ef1-4e1e-88c5-66e467fef632                                                | OS::Neutron::SecurityGroup   | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | subnet                      | ad09494b-7d90-4c80-8528-1e4c28df598b                                                | OS::Neutron::Subnet          | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | web_server_scaledown_policy | 599b3a451758428db4d8ae97c611ac9b                                                    | OS::Heat::ScalingPolicy      | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 | web_server_scaleup_policy   | 9b12ca669d6a4e88b2494671c79a98e6                                                    | OS::Heat::ScalingPolicy      | CREATE_COMPLETE | 2016-09-13T14:30:06Z |
 +-----------------------------+-------------------------------------------------------------------------------------+------------------------------+-----------------+----------------------+

 ~~~

#### 2/ Add nodes to MyCloudManager 's Zabbix

Install zabbix agent in instances via the web interface of MyCloudManager.
 ![mcm](img/ajouterinstances.png)

#### 3/ Mise à jour le template OS Linux Zabbix

 Update the Linux OS template, this template contains a new `item` two new` `triggers` and two new macors` in order to calculate the percentage use of the CPU in every minute.

 ![template1](img/updatetemp1.png)

 Then select the template and click import.

 ![template2](img/updatetemp2.png)


#### 4/ Create the both actions scale up and scale down

 To have the urls to scale up and down, you have to query the outputs (Output) of your stack via the Url control scale up:

 ~~~bash
 openstack stack output show -f json your_stack_name scale_up_url | jq '.output_value'
 ~~~

 Scale down url :

 ~~~bash
 openstack stack output show -f json your_stack_name scale_dn_url | jq '.output_value'
 ~~~

Then we go to the steps in order to create the both actions scale up and scale down:

 1/ Create `host groups` who represents your instances.

 ![action1](img/hostgroups.png)

 2/ Create action scale down (use the same way for creating scale up)

 ![action2](img/action1.png)

 Add the conditions.

 ![action3](img/action2.png)

 Put the following commands to scale down (scale up) in the input Commands.

~~~bash
 export OS_AUTH_URL=https://identity.fr1.cloudwatt.com/v2.0
 export OS_TENANT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxx
 export OS_TENANT_NAME="xxxxxxxxxxxxxxxxxxxxx"
 export OS_PROJECT_NAME="xxxxxxxxxxxxxxxxxxxxx"
 export OS_USERNAME="xxxxxxxxxxxxxxx@cloudwatt.com"
 export OS_PASSWORD=*************************
 export OS_REGION_NAME="fr1"
 curl -k -X POST “url de scaling down ou scaling up“
~~~

 ![action4](img/action3.png)

 Your action is created.

 ![action5](img/action4.png)

 3/ For testing the scaling up and scaling down, type the following command in server:

~~~bash
$ sudo apt-get install stress
$ stress --cpu 90 --io 2 --vm 2 --vm-bytes 512M --timeout 600
~~~

Don't forget to add each new stack appeared in the `Host Groupe` of your stack.

#### How to customize your template

In this article we used as `system.cpu.util [,, AVG1]` item in order to calculate cpu usage poucentage.
You can use others items (usage of RAM or disk ...) for the autoscaling.
That [a list of items](https://www.zabbix.com/documentation/2.0/manual/config/items/itemtypes/zabbix_agent)

 For creating item.

![item](img/item.png)

You can also change or create others.

![macro](img/macro.png)

You can create a trigger.

![triggers](img/triggers.png)


### Other resources you could be interested in:

 * [ Autoscaling ](https://dev.cloudwatt.com/fr/blog/passez-votre-infrastructure-openstack-a-l-echelle-avec-heat.html)
 * [ Zabbix](https://www.zabbix.com/documentation/3.0/manual/introduction/features)
 * [ MycloudManager ](https://www.cloudwatt.com/fr/applications/mycloudmanager.html)


 -----
 Have fun. Hack in peace.

 The CAT
