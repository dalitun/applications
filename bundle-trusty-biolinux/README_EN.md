## BioLinux #

![logo](images/Biolinux.png)

Bio-Linux 8 is a powerful, free bioinformatics workstation platform that can be installed on anything from a laptop to a large server, or run as a virtual machine. Bio-Linux 8 adds more than 250 bioinformatics packages to an Ubuntu Linux 14.04 LTS base, providing around 50 graphical applications and several hundred command line tools. The Galaxy environment for browser-based data analysis and workflow construction is also incorporated in Bio-Linux 8.


### The versions

* BioLinux 8

### The prerequisites to deploy this stack

* an internet acces
* a Linux shell
* a [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact), with an [existing keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
* the tools [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
* a local clone of the git repository [Cloudwatt applications](https://github.com/cloudwatt/applications)

### Size of the instance

Per default, the script is proposing a deployement on an instance type "Small" (s1.cw.small-1).  Instances are charged by the minute and capped at their monthly price (you can find more details on the [Tarifs page](https://www.cloudwatt.com/fr/produits/tarifs.html) on the Cloudwatt website). Obviously, you can adjust the stack parameters, particularly its defaut size.


## Start-up

### Initialize the environment

Have your Cloudwatt credentials in hand and click [HERE](https://console.cloudwatt.com/project/access_and_security/api_access/openrc/).
If you are not logged in yet, you will go thru the authentication screen then the script download will start. Thanks to it, you will be able to initiate the shell acccesses towards the Cloudwatt APIs.

Source the downloaded file in your shell. Your password will be requested.

~~~ bash
$ source COMPUTE-[...]-openrc.sh
Please enter your OpenStack Password:

~~~

Once this done, the Openstack command line tools can interact with your Cloudwatt user account.


### Start up the instance

In a shell, run this command :

~~~bash
$ nova boot --flavor m1.tiny --image bundle-biolinux-8 --nic net-id=NET_ID --security-group your_sec_groupe --key-name your_key_pair your_instance_name
~~~

### Enjoy

To access the machine, you have 2 choices:

1) By ssh.
~~~bash
 $ ssh cloud@floating_ip -i your_key_pair.pem
~~~

2) By nomachine client.
User is `cloud` and the default password `cloudwatt`.

![img1](images/1.png)
![img2](images/2.png)
![img3](images/3.png)
![img4](images/4.png)
![img5](images/5.png)
![img6](images/6.png)

I advise you to change the default password by logging in via ssh.

~~~bash
$ssh cloud@floating_ip -i your_key_pair.pem
$ passwd
~~~

### Resources you could be interested in:

* [BioLinux homepage](http://environmentalomics.org/bio-linux/)

-----
Have fun. Hack in peace.
