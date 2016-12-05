# 5 Minutes Stacks, episode 25 : Pfsense #

## Episode 25 : Pfsense

![pfsenselogo](http://actuto.azurewebsites.net/wp-content/uploads/2014/10/pfsense-logo.png)

pfSense is an open source firewall/router computer software distribution based on FreeBSD. It is installed on a physical computer or a virtual machine to make a dedicated firewall/router for a network and is noted for its reliability and offering features often only found in expensive commercial firewalls. It can be configured and upgraded through a web-based interface, and requires no knowledge of the underlying FreeBSD system to manage. PfSense is commonly deployed as a perimeter firewall, router, wireless access point, DHCP server, DNS server, and as a VPN endpoint. PfSense supports installation of third-party packages like Snort or Squid through its Package Manager. It ensures the security perimeter.

This stack will deploy two instances: one is Pfsense application, the second for Pfsense administration is based on Ubuntu. Here is the architecture diagram.

![pfsense_schema](img/pfsense.png)

### The Versions
- Pfsense 2.3
- Ubuntu Trusty 14.04

### The prerequisites to deploy this stack

These should be routine by now:

 * Internet access
 * A Linux shell
 * A [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact) with a [valid keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * The tools of the trade: [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
 * A local clone of the [Cloudwatt applications](https://github.com/cloudwatt/applications) git repository (if you are creating your stack from a shell)

## Size of the instance

By default, the stack deploys on an instance of type "standard-1" (n2.cw.standard-1). A variety of other instance types exist to suit your various needs, allowing you to pay only for the services you need. Instances are charged by the minute and capped at their monthly price (you can find more details on the [Pricing page](https://www.cloudwatt.com/en/pricing.html) on the Cloudwatt website).

Stack parameters, of course, are yours to tweak at your fancy.

### By the way...

If you do not like command lines, you can go directly to the "run it thru the console" section by clicking [here](#console)

## What will you find in the repository

 Once you have cloned the github, you will find in the `bundle-freebsd-pfsense/` repository:

 * `bundle-freebsd-pfsense.heat.yml`: HEAT orchestration template. It will be use to deploy the necessary infrastructure.
 * `stack-start.sh`: Stack launching script. This is a small script that will save you some copy-paste.
 * `stack-get-url.sh`: Admin's Flotting IP recovery script.

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

With the `bundle-freebsd-pfsense.heat.yml` file, you will find at the top a section named `parameters`.In order to be able to deploy your stack without problems, you complete all the parameters below.This is within this same file that you can adjust the instances size by playing with `flavor_name_fw` and `flavor_name_client` parameters.


~~~ yaml
heat_template_version: 2013-05-23


description: All-in-one Pfsense stack


parameters:
  keypair_name:
    default: my-keypair-name                   <-- Rajoutez cette ligne avec le nom de votre paire de clés
    description: Keypair to inject in instance
    label: SSH Keypair
    type: string

  flavor_name:
    default: n1.cw.standard-2
    description: Flavor to use for the deployed instance
    type: string
    label: Instance Type (Flavor)
[...]
~~~
In a shell, run the script `stack-start.sh`:

~~~bash
$ ./stack-start.sh Pfsense Votre_keypair_name private_net public_net
~~~

Exemple :

~~~bash
$ ./stack-start.sh Pfsense your_keypair_name private_net public_net
+--------------------------------------+-----------------+--------------------+----------------------+
| id                                   | stack_name      | stack_status       | creation_time        |
+--------------------------------------+-----------------+--------------------+----------------------+
| ee873a3a-a306-4127-8647-4bc80469cec4 | Pfsense         | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
+--------------------------------------+-----------------+--------------------+----------------------+
~~~

* private_net : Lan network (ex: 192.168.0.0/24)
* public_net : Wan network (ex : 10.0.0.0/24)


Within **5 minutes** the stack will be fully operational. (Use `watch` to see the status in real-time)

~~~bash
$ watch heat resource-list Pfsense
+------------------+-----------------------------------------------------+---------------------------------+-----------------+----------------------+
| resource_name    | physical_resource_id                                | resource_type                   | resource_status | updated_time         |
+------------------+-----------------------------------------------------+---------------------------------+-----------------+----------------------+
| floating_ip      | 44dd841f-8570-4f02-a8cc-f21a125cc8aa                | OS::Neutron::FloatingIP         | CREATE_COMPLETE | 2015-11-25T11:03:51Z |
| security_group   | efead2a2-c91b-470e-a234-58746da6ac22                | OS::Neutron::SecurityGroup      | CREATE_COMPLETE | 2015-11-25T11:03:52Z |
| network          | 7e142d1b-f660-498d-961a-b03d0aee5cff                | OS::Neutron::Net                | CREATE_COMPLETE | 2015-11-25T11:03:56Z |
| subnet           | 442b31bf-0d3e-406b-8d5f-7b1b6181a381                | OS::Neutron::Subnet             | CREATE_COMPLETE | 2015-11-25T11:03:57Z |
| server           | f5b22d22-1cfe-41bb-9e30-4d089285e5e5                | OS::Nova::Server                | CREATE_COMPLETE | 2015-11-25T11:04:00Z |
| floating_ip_link | 44dd841f-8570-4f02-a8cc-f21a125cc8aa-`admin_floating_ip`  | OS::Nova::FloatingIPAssociation | CREATE_COMPLETE | 2015-11-25T11:04:30Z |
  +------------------+-----------------------------------------------------+-------------------------------+-----------------+----------------------
~~~
The `start-stack.sh` script takes care of running the API necessary requests to execute the normal heat template which:

* Starts pfsense based instance
* `admin_floating_ip` is admin machine flotting Ip .  

<a name="console" />

## All of this is fine, but...

### You do not have a way to create the stack from the console?

We do indeed! Using the console, you can deploy a Pfsense server:

1.	Go the Cloudwatt Github in the [applications/bundle-freebsd-pfsense.heat](https://github.com/cloudwatt/applications/tree/master/bundle-freebsd-pfsense) repository
2.	Click on the file named `bundle-freebsd-pfsense.heat.yml` (or `bundle-freebsd-pfsense.restore.heat.yml` to [restore from backup](#backup))
3.	Click on RAW, a web page will appear containing purely the template
4.	Save the file to your PC. You can use the default name proposed by your browser (just remove the .txt)
5.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console
6.	Click on « Launch stack », then « Template file » and select the file you just saved to your PC, and finally click on « NEXT »
7.	Name your stack in the « Stack name » field
8.	Fill in all required parameters
9.	Choose your instance size using the « Instance Type » dropdown and click on « LAUNCH »

The stack will be automatically generated (you can see its progress by clicking on its name). When all modules become green, the creation will be complete. You can then go to the "Instances" menu to find the floating IP, or simply refresh the current page and check the Overview tab for a handy link.

If you've reached this point, you're already done! Go enjoy Pfsense!

## Enjoy
In this example you have a pfsense server connects on both networks LAN and WAN, you have also an Ubuntu 14.04 connects to the same LAN of pfsense.You can manage your firewall from your admin machine (ubuntu).
you can connect to your pfsense by typing on your terminal this command:

~~~bash
$ lynx https://privateip_pfsense
~~~

![lynx](img/lynx.png)

for logging you use  **Username: admin** and **Password: pfsense**.

![lynx1](img/lynx2.png)

You can install a GUI interface on your Admin machine or you can use also windows machine ,otherwise you can create two ssh tunnels in order to manager pfsense by your own machine:

1) Type the following command:

~~~bash
$ sudo ssh privateIpPfsense -l root -i $YOU_KEYPAIR_PATH -L 443:localhost:443 -i private_key
~~~

in this case you have to use your private key.

or

~~~bash
$ sudo ssh privateIpPfsense -l root -L 443:localhost:443
~~~

root's password is "pfsense". I advise you to change it.

2) On your own machine type this command in order to open the tunnel between your machine and the admin Machine.

~~~bash
sudo ssh FloatingIPadmin -l cloud -i $YOU_KEYPAIR_PATH -L 5555:localhost:443
~~~

3)Then you can manage pfsense by this url `https://localhost:5555`,with **username:admin** and **password: pfsense**:

![pfsense1](img/pfsense1.png)

Now you can configure your firewall:

![pfsense2](img/pfsense2.png)

If you have problems in the connection speed on the instances, connecte to your PFsense, you can go to the page **System>Advanced>Networking**, then check this option **Disable hardware checksum offload**.

![pfsense3](img/pfsense3.png)

If this does not correct the problem, we remind you that the bandwidths of the instances are not all the same for example to have a bandwidth equal to 800 Mb/s you must choose one of these flavors (n1.cw.standard-4,n2.cw.standard-4,n1.cw.highcpu-4,n1.cw.highmem-4,n2.cw.highmem-4 ou i2.cw.largessd-4).
For knowing the bandwidths of our flavors click on this [link](https://www.cloudwatt.com/en/products/servers/tarifs.html).

## So watt ?

The goal of this tutorial is to accelerate your start. At this point **you** are the master of the stack.

You now have an SSH access point on your virtual machine through the floating-IP and your private keypair (default user name `cloud`).

* You have access to the web interface with https via the floating IP from ubuntu server.

### Here are some news sites to learn more:

- https://www.pfsense.org/
- https://forum.pfsense.org

----
Have fun. Hack in peace.
