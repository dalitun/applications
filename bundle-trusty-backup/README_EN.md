# 5 Minutes Stacks, épisode 23 : Duplicity #

## Episode 23 : Duplicity

![logoduplicity](http://3.bp.blogspot.com/-XGwKwPUH8wM/UPKzagbzUmI/AAAAAAAABoI/XQf7Of5FXts/s1600/blog-domenech-org-ubuntu-deja-dup-amazon-web-services-s3-logo.png)

The duplicity utility is a tool **in command line** allowing to make incremental backup of files and directories.

Duplicity backs directories by producing encrypted tar-format volumes and uploading them to a remote or local file server. Because duplicity uses librsync, the incremental archives are space efficient and only record the parts of files that have changed since the last backup. Because duplicity uses GnuPG to encrypt and/or sign these archives, they will be safe from spying and/or modification by the server.

### The Versions
 - Ubuntu Trusty 14.04.2
 - Duplicity 0.7.06

### The prerequisites to deploy this stack

These should be routine by now:

 * Internet access
 * A Linux shell
 * A [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact) with a [valid keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * The tools of the trade: [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
 * A local clone of the [Cloudwatt applications](https://github.com/cloudwatt/applications) git repository (if you are creating your stack from a shell)


### Size of the instance

By default, the stack deploys on an instance of type "Small" (s1.cw.small-1). A variety of other instance types exist to suit your various needs, allowing you to pay only for the services you need. Instances are charged by the minute and capped at their monthly price (you can find more details on the [Tarifs page](https://www.cloudwatt.com/fr/produits/tarifs.html) on the Cloudwatt website).

Duplicity stacks follow in the footsteps of our previous volume-using stacks, making good use of Cinder Volume Storage to ensure the protection of your data and allowing you to pay only for the space you use. Volume size is fully adjustable, and the Duplicity stack can support tens to tens of hundreds of gigabytes worth of project space.

 Stack parameters, of course, are yours to tweak at your fancy.

### By the way...

If you do not like command lines, you can go directly to the "run it thru the console" section by clicking [here](#console)

## What will you find in the repository

 Once you have cloned the github, you will find in the `bundle-trusty-backup/` repository:

 * `bundle-trusty-backup.heat.yml`: HEAT orchestration template. It will be use to deploy the necessary infrastructure.
 * `stack-start.sh`: Stack launching script. This is a small script that will save you some copy-paste.
 * `stack-get-url.sh`: Flotting IP recovery script.

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

With the `bundle-trusty-backup.heat.yml` file, you will find at the top a section named `parameters`. The sole mandatory parameter to adjust is the one called `keypair_name`. Its `default` value must contain a valid keypair with regards to your Cloudwatt user account. This is within this same file that you can adjust the instance size by playing with the `flavor` parameter.

~~~ yaml
heat_template_version: 2016-02-09


description: Basic all-in-one backup stack


parameters:
  keypair_name:
    default: keypair_name        <-- Indicate here your keypair
    description: Keypair to inject in instances
    type: string

  flavor_name:
    default: s1.cw.small-1              <-- indicate here the flavor size
    description: Flavor to use for the deployed instance
    type: string
    constraints:
      - allowed_values:
          - s1.cw.small-1
          - n1.cw.standard-1
          - n1.cw.standard-2
          - n1.cw.standard-4
          - n1.cw.standard-8
          - n1.cw.standard-12
          - n1.cw.standard-16

[...]
~~~

In a shell, run the script `stack-start.sh`:

~~~
./stack-start.sh stack_name
~~~

Exemple :

~~~bash
$ ./stack-start.sh DUPLICITY
+--------------------------------------+-----------------+--------------------+----------------------+
| id                                   | stack_name      | stack_status       | creation_time        |
+--------------------------------------+-----------------+--------------------+----------------------+
| ee873a3a-a306-4127-8647-4bc80469cec4 | DUPLICITY       | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
+--------------------------------------+-----------------+--------------------+----------------------+
~~~

Within 5 minutes the stack will be fully operational. (Use `watch` to see the status in real-time)

~~~bash
$ watch heat resource-list DUPLICITY
+------------------+-----------------------------------------------------+---------------------------------+-----------------+----------------------+
| resource_name    | physical_resource_id                                | resource_type                   | resource_status | updated_time         |
+------------------+-----------------------------------------------------+---------------------------------+-----------------+----------------------+
| floating_ip      | 44dd841f-8570-4f02-a8cc-f21a125cc8aa                | OS::Neutron::FloatingIP         | CREATE_COMPLETE | 2015-11-25T11:03:51Z |
| security_group   | efead2a2-c91b-470e-a234-58746da6ac22                | OS::Neutron::SecurityGroup      | CREATE_COMPLETE | 2015-11-25T11:03:52Z |
| network          | 7e142d1b-f660-498d-961a-b03d0aee5cff                | OS::Neutron::Net                | CREATE_COMPLETE | 2015-11-25T11:03:56Z |
| subnet           | 442b31bf-0d3e-406b-8d5f-7b1b6181a381                | OS::Neutron::Subnet             | CREATE_COMPLETE | 2015-11-25T11:03:57Z |
| server           | f5b22d22-1cfe-41bb-9e30-4d089285e5e5                | OS::Nova::Server                | CREATE_COMPLETE | 2015-11-25T11:04:00Z |
| floating_ip_link | 44dd841f-8570-4f02-a8cc-f21a125cc8aa-`floating IP`  | OS::Nova::FloatingIPAssociation | CREATE_COMPLETE | 2015-11-25T11:04:30Z |
  +------------------+-----------------------------------------------------+-------------------------------+-----------------+----------------------
~~~

The `start-stack.sh` script takes care of running the API necessary requests to execute the normal heat template which:

* Starts an Ubuntu Trusty Tahr based instance
* Expose it on the Internet via a floating IP.

![Backuplogo](http://www.nordic-vikings.net/wp-content/uploads/2013/06/linuxbackup.jpg)

### All of this is fine, but you do not have a way to create the stack from the console?

We do indeed! Using the console, you can deploy a duplicity server:

1.	Go the Cloudwatt Github in the [applications/bundle-trusty-duplicity](https://github.com/cloudwatt/applications/tree/master/bbundle-trusty-backup) repository
2.	Click on the file named `bundle-trusty-duplicity.heat.yml` (or `bundle-trusty-duplicity.restore.heat.yml` to [restore from backup](#backup))
3.	Click on RAW, a web page will appear containing purely the template
4.	Save the file to your PC. You can use the default name proposed by your browser (just remove the .txt)
5.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console
6.	Click on « Launch stack », then « Template file » and select the file you just saved to your PC, and finally click on « NEXT »
7.	Name your stack in the « Stack name » field
8.	Enter the name of your keypair in the « SSH Keypair » field
9.  Write a passphrase that will be used for encrypting backups
10.	Choose your instance size using the « Instance Type » dropdown and click on « LAUNCH »

The stack will be automatically generated (you can see its progress by clicking on its name). When all modules become green, the creation will be complete. You can then go to the "Instances" menu to find the floating IP, or simply refresh the current page and check the Overview tab for a handy link.

If you've reached this point, you're already done! Go enjoy Duplicity!

### A one-click chat sounds really nice...

... Good! Go to the [Apps page](https://www.cloudwatt.com/fr/applications/index.html) on the Cloudwatt website, choose the apps, press **DEPLOYER** and follow the simple steps... 2 minutes later, a green button appears... **ACCEDER**: you have your Duplicity server!

### Enjoy

Once all this makes you can connect on your server in SSH by using your keypair beforehand downloaded on your compute,

You are now in possession of a backup server,
it's able to generating a coded backup and to copy them where you want, duplicity is able to making back up full an incremental.
Be carreful if you make a incremental backup, Duplicity needs all of them to restore backup,

For advice make a full backup in week and one incremental per days to have a clean backup solution,

By default all codes and passphrase generated by the application are stored in `/etc/duplicity`.

To automate the backup you can use CRON installed by default on the server. it's going to allow you to schedule your backup.

Generating incremental backups encrypt , including databases , make's duplicity an ideal backup solution for self-hosting .


Start backup command

~~~
duplicity /your_directory file:///var/backups/duplicity/ --include-globbing-filelist filelist.txt --exclude '**'
~~~

Start backup command in a remote server:
~~~
duplicity --encrypt-key key_from_GPG --exclude files_to_exclude --include files_to_include path_to_back_up sftp://root@backupHost//remotebackup/duplicityDroplet
~~~

Start the restore command:
~~~
duplicity restore file:///var/backups/duplicity/ /any/directory/
~~~  
You can backup au database with sql export in .sql
~~~
mysql -uroot -ppassword --skip-comments -ql my_database > my_database.sql
~~~
For added security you can / must export your backup on another machine with rcync command:
~~~
rsync -rvP --partial-dir=/my/local/tmpbackup --ignore-existing --stats -h server:/var/backups/duplicity/ /my/local/backup/
~~~

## So watt?

The goal of this tutorial is to accelerate your start. At this point **you** are the master of the stack.

You now have an SSH access point on your virtual machine through the floating-IP and your private keypair (default user name `cloud`).

You can start developing your backup plan, here are useful entry points:

* `/etc/duplicity` : all key and passphrase needed to operate duplicity

* Here are some news sites to learn more:

    - http://duplicity.nongnu.org/
    - http://www.linuxuser.co.uk/tutorials/create-secure-remote-backups-using-duplicity-tutorial
    - https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu
    
    -----
    Have fun. Hack in peace.
