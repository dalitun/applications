# 5 Minutes Stacks, 25 episode : JeStart #

## Episode 20 : JeStart
.

## Preparations


### The prerequisites to deploy this stack

 * an internet acces
 * a Linux shell
 * a [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact), with an [existing keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * the tools [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
 * a local clone of the git repository [Cloudwatt applications](https://github.com/cloudwatt/applications)


### By the way...

 If you do not like command lines, you can go directly to the "run it through the console" section by clicking [here](#console)

## What will you find in the repository

 Once you have cloned the github, you will find in the `JeStart/` repository:

 * `JeStart.heat.yml`: HEAT orchestration template. It will be use to deploy the necessary infrastructure.

## Start-up

### Initialize the environment

 Have your Cloudwatt credentials in hand and click [HERE](https://console.cloudwatt.com/project/access_and_security/api_access/openrc/).
 If you are not logged in yet, you will go thru the authentication screen then the script download will start. Thanks to it, you will be able to initiate the shell accesses towards the Cloudwatt APIs.

 Source the downloaded file in your shell. Your password will be requested.

 ~~~ bash
 $ source COMPUTE-[...]-openrc.sh
 Please enter your OpenStack Password:

 ~~~

 Once this done, the Openstack command line tools can interact with your Cloudwatt user account.

### Adjust the parameters

 With the `JeStart.heat.yml` file, you will find at the top a section named `parameters`.

 ~~~ yaml
   heat_template_version: 2013-05-23

   description: Template help you to start in your tenant.

   parameters:
     keypair_name_prefix:
       default: mykeypair                  <-- Indicate here your keypair name prefix
       type: string
       label: key Name prefix
       description: the keypair name.
     net_cidr:
       default: 192.168.1.0/24            <-- Indicate here network cidr ip address /24
       type: string
       label: /24 cidr of your network
       description: /24 cidr of private network

 [...]
 ~~~
### Start stack

 In a shell, run this command:

 ~~~
 heat stack-create nom_de_votre_stack -f JeStart.heat.yml -Pkeypair_name_prefix=keypair_prefix -Pnet_cidr=192.168.1.0/24
 ~~~

 Exemple :

 ~~~bash
 $ heat stack-create mysatck_name -f JeStart.heat.yml -Pkeypair_name_prefix=prefix -Pnet_cidr=192.168.1.0/24
 +--------------------------------------+-----------------+--------------------+----------------------+
 | id                                   | stack_name      | stack_status       | creation_time        |
 +--------------------------------------+-----------------+--------------------+----------------------+
 | ee873a3a-a306-4127-8647-4bc80469cec4 | your_stack_name       | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
 +--------------------------------------+-----------------+--------------------+----------------------+
 ~~~

  Wait a few minitues the stack will be fully operational.

 ~~~bash
 $ heat resource-list your_stack_name
 +---------------+--------------------------------------+----------------------------+-----------------+----------------------+
 | resource_name | physical_resource_id                 | resource_type              | resource_status | updated_time         |
 +---------------+--------------------------------------+----------------------------+-----------------+----------------------+
 | keypair       | JeStart-mykeypair                    | OS::Nova::KeyPair          | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
 | network       | 165fff85-a6ac-4bdd-ad63-ac2ba8e58f45 | OS::Neutron::Net           | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
 | sg            | 9d5f6961-8eb2-4e59-b637-fa3f70659b55 | OS::Neutron::SecurityGroup | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
 | subnet        | f5d63c5e-1fb5-4ed9-9927-a7025c5dbd95 | OS::Neutron::Subnet        | CREATE_COMPLETE | 2016-06-02T16:14:43Z |
 +---------------+--------------------------------------+----------------------------+-----------------+----------------------+
 ~~~

The `start-stack.sh` script takes care of running the API necessary requests to execute the normal heat template which:

* Starts an Ubuntu Trusty Tahr based instance
* Expose it on the Internet via a floating IP.


## All of this is fine,
### but you do not have a way to create the stack from the console?

We do indeed! Using the console, you can deploy a mail server:

1.	Go the Cloudwatt Github in the [applications/bundle-trusty-mail]https://github.com/cloudwatt/applications/tree/master/JeStart) repository
2.	Click on the file named `JeStart.heat.yml` (or `JeStart.restore.heat.yml` to [restore from backup](#backup))
3.	Click on RAW, a web page will appear containing purely the template
4.	Save the file to your PC. You can use the default name proposed by your browser (just remove the .txt)
5.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console
6.	Click on « Launch stack », then « Template file » and select the file you just saved to your PC, and finally click on « NEXT »
7.	Name your stack in the « Stack name » field
8.	Enter the name of your keypair in the « SSH Keypair » field
9.  Write a passphrase that will be used for encrypting backups
10.	Choose your instance size using the « Instance Type » dropdown and click on « LAUNCH »

The stack will be automatically generated (you can see its progress by clicking on its name). When all modules become green, the creation will be complete. You can then go to the "Instances" menu to find the floating IP, or simply refresh the current page and check the Overview tab for a handy link.

If you've reached this point, you're already done! Go enjoy Mail!

### A one-click chat sounds really nice...

... Good! Go to the [Apps page](https://www.cloudwatt.com/fr/applications/index.html) on the Cloudwatt website, choose the apps, press **DEPLOYER** and follow the simple steps... 2 minutes later, a green button appears... **ACCEDER**: you have your mail server!


## Enjoy
for downloading your private key, consult this url `https://console.cloudwatt.com/project/access_and_security/keypairs/nom_votre_stack-prefix/download/`.
Then click on `Download key pair "your_stack_name-prefix"`.

You can use a shell script in order to shelve and unshelve the instances  in your tenant.

You can create a cron to shelve your instances every Friday at midnight.

~~~bash
$ source COMPUTE-[...]-openrc.sh
Please enter your OpenStack Password:
$ crontab -e
0 0 * * 5 /path/shelveunshelve.sh shelve
~~~

You can create a cron to unshelve your instances every Monday at 5 am.

~~~bash
$ source COMPUTE-[...]-openrc.sh
Please enter your OpenStack Password:
$ crontab -e
0 5 * * 1 /path/shelveunshelve.sh unshelve
~~~


### Other resources you could be interested in:
* [ Openstack Home page](https://www.openstack.org/)

----
Have fun. Hack in peace.
