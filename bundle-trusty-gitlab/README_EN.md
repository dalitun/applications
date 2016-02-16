# 5 Minutes Stacks, Episode seven: GitLab

## Episode seven: GitLab

For this seventh episode, we took on GitLab. GitLab is an awesome tool which brings the power and dexterity of applications such as BitBucket and GitHub to personal servers. It allows anyone to become master of their own remote Git repository, and control and view the modifications done to its projects by its users using GitLab's sleek interface designed by its dedicated community.

Following this tutorial, you will create an Ubuntu Trusty Tahr instance, pre-configured with GitLab on https port 443 (automatically redirects from port 80). All of GitLab's data will be stored in a dedicated volume tailored to your needs, capable of creating backups upon request. From GitLab's integrated administration panel you will be able to tweak the privacy and various other settings of your GitLab instance to the slightest detail, giving you full reign on you and your team's all-important Git experience.

## Preparations

### The version

* GitLab (gitlab-ce) 7.14.0-ce.0 via omnibus

### The prerequisites to deploy this stack

These should be routine by now:

* Internet access
* A Linux shell
* A [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact) with a [valid keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
* The tools of the trade: [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
* A local clone of the [Cloudwatt applications](https://github.com/cloudwatt/applications) git repository

### Size of the instance

Unlike previous stacks the minimum instance type we recommend is a light "Standard" (n1.cw.standard-1). This is due to the minimum memory space recommended by GitLab, and while it is possible to deploy on a smaller instance, it would likely lead to unintended consequences. Instances are charged by the minute and capped at their monthly price (you can find more details on the [Tarifs page](https://www.cloudwatt.com/fr/produits/tarifs.html) on the Cloudwatt website).

Furthermore, our GitLab stacks are tailored to make good use of Cinder Volume Storage. This ensures the protection of your precious projects, and allows you to pay only for the space you use. Volume size can be selected from the console, and the GitLab stack can support tens to tens of hundreds of gigabytes worth of project space.

Stack parameters, of course, are yours to tweak at your fancy.

### By the way...

You may have noticed a few extra files in the directory. The new `.restore` heat and `backup.sh` script enable you to make the best use of Cinder Volume Storage, allowing the creation of Cinder Volume Backups: Save states of your GitLab stack's volume for you to redeploy at your fancy with the `.restore` heat template.

While creating a 'restored' stack from a backup can be accomplished from the [console](#console), backups must be initialized with our handy backup script and take a curt 5 minutes from start to full return of functionality. [(More about backing up your GitLab...)](#backup)

Of course, normal stacks can still be generated directly from the [console](#console), should command line make you squeamish.

## What will you find in the repository

Once you have cloned the github, you will find in the `bundle-trusty-gitlab/` repository:

* `bundle-trusty-gitlab.heat.yml`: HEAT orchestration template. It will be use to deploy the necessary infrastructure.
* `bundle-trusty-gitlab.restore.heat.yml`: HEAT orchestration template. It deploys the necessary infrastructure, and restores your data from a previous backup!
* `backup.sh`: Backup creation script. This magical script that will save you from certain demise, and completes a full volume backup ready for later redeployment in only 5 minutes.
* `stack-start.sh`: Stack launching script. This is a small script that will save you 10 seconds (over and over), courtesy of Cloudwatt.
* `stack-get-url.sh`: A handy-dandy URL maker. Just look at all this time we save you!

## Start-up

### Initialize the environment

Have your Cloudwatt credentials in hand and click [HERE](https://console.cloudwatt.com/project/access_and_security/api_access/openrc/).
If you are not logged in yet, complete the authentication and the credentials script will download. With it, you will be able to wield the amazing powers of the Cloudwatt APIs.

Source the downloaded file in your shell. Your password will be requested.

~~~ bash
$ source COMPUTE-[...]-openrc.sh
Please enter your OpenStack Password:

$ [whatever mind-blowing stuff you have planned...]
~~~

Once this done, the Openstack command line tools can interact with your Cloudwatt user account.

### Adjust the parameters

In the `.heat.yml` files, you will find a section named `parameters` near the top. The sole mandatory parameter is `keypair_name`. Its `default` value should contain a valid keypair with regards to your Cloudwatt user account, if you wish to avoid repeatedly typing it into the command line.

It is within this same file that you can adjust (and set the defaults for) the instance type, volume size, and volume type by playing with the `flavor`, `volume_size`, and `volume_type` parameters accordingly.

By default, the stack network and subnet are generated for the stack, in which the GitLab server sits alone. This behavior can be changed within the `.heat.yml` as well, if need be.

~~~ yaml
heat_template_version: 2013-05-23


description: All-in-one GitLab stack


parameters:
  keypair_name:
    default: my-keypair-name                <-- Indicate your keypair here
    description: Paire de cles a injecter dans instance - Keypair to inject in instance
    label: Paire de cles SSH - SSH Keypair
    type: string

  flavor_name:
    default: n1.cw.standard-1               <-- Indicate your instance type here
    description: Type instance a deployer - Flavor to use for the deployed instance
    type: string
    label: Type instance - Instance Type (Flavor)
    constraints:
      - allowed_values:
          [...]

  volume_size:
    default: 10                             <-- Indicate your volume size here
    description: Size of Volume for GitLab Storage (Gigabytes)
    label: GitLab Volume Size
    type: number
    constraints:
      - range: { min: 10, max: 10000 }
        description: Volume must be at least 10 gigabytes

  volume_type:
    default: standard                       <-- Indicate your volume type here
    description: Performance flavor of the linked Volume for GitLab Storage
    label: GitLab Volume Type
    type: string
    constraints:
      - allowed_values:
          - standard
          - performant

resources:
  network:                                  <-- Network settings
    type: OS::Neutron::Net

  subnet:                                   <-- Subnet settings
    type: OS::Neutron::Subnet
    properties:
      network_id: { get_resource: network }
      ip_version: 4
      cidr: 10.0.1.0/24
      allocation_pools:
        - { start: 10.0.1.100, end: 10.0.1.199 }
[...]
~~~

### Start up the stack

In a shell, run the script `stack-start.sh` with its unique new name as parameter:

~~~ bash
$ ./stack-start.sh GitCERN
+--------------------------------------+------------+--------------------+----------------------+
| id                                   | stack_name | stack_status       | creation_time        |
+--------------------------------------+------------+--------------------+----------------------+
| xixixx-xixxi-ixixi-xiixxxi-ixxxixixi | GitCERN    | CREATE_IN_PROGRESS | 2025-10-23T07:27:69Z |
+--------------------------------------+------------+--------------------+----------------------+
~~~

Last, wait 5 minutes until the deployment been completed. (Use watch to see the status in real-time)

~~~ bash
$ watch heat stack-list
+--------------------------------------+------------+-----------------+----------------------+
| id                                   | stack_name | stack_status    | creation_time        |
+--------------------------------------+------------+-----------------+----------------------+
| xixixx-xixxi-ixixi-xiixxxi-ixxxixixi | GitCERN    | CREATE_COMPLETE | 2025-10-23T07:27:69Z |
+--------------------------------------+------------+-----------------+----------------------+
~~~

### Enjoy

Once all of this done, you can run the `stack-get-url.sh` script.

~~~ bash
$ ./stack-get-url.sh GitCERN
GitCERN http://70.60.637.17
~~~

As shown above, it will parse the assigned floating IP of your stack into a URL link. You can then click or paste this into your browser of choice, confirm the use of the self-signed certificate, and bask in the glory of a secure GitLab instance.

## In the background

The `start-stack.sh` script takes care of running the API necessary requests to execute the normal heat template which:
* starts an Ubuntu Trusty Tahr based instance
* attaches an exposed floating IP
* starts, attaches, and formats a fresh volume for GitLab to exploit
* reconfigures GitLab to store its data in the volume and use the new floating ip

<a name="console" />

### All of this is fine, but you do not have a way to create the stack from the console?

We do indeed! Using the console, you can deploy a GitLab server:

1.	Go the Cloudwatt Github in the [applications/bundle-trusty-gitlab](https://github.com/cloudwatt/applications/tree/master/bundle-trusty-gitlab) repository
2.	Click on the file named `bundle-trusty-gitlab.heat.yml` (or `bundle-trusty-gitlab.restore.heat.yml` to [restore from backup](#backup))
3.	Click on RAW, a web page will appear containing purely the template
4.	Save the file to your PC. You can use the default name proposed by your browser (just remove the .txt)
5.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console
6.	Click on « Launch stack », then « Template file » and select the file you just saved to your PC, and finally click on « NEXT »
7.	Name your stack in the « Stack name » field
8.	Enter the name of your keypair in the « SSH Keypair » field
9.	Confirm the volume size (in gigabytes) in the « GitLab Volume Size » field
10.	Choose your instance size using the « Instance Type » dropdown and click on « LAUNCH »

The stack will be automatically generated (you can see its progress by clicking on its name). When all modules become green, the creation will be complete. You can then go to the "Instances" menu to find the floating IP, or simply refresh the current page and check the Overview tab for a handy link.

If you've reached this point, you're already done! Go enjoy GitLab!

<a name="backup" />

## Back up and Restoration

Backing your GitLab, sounds like great idea, right? After all, *ipsa scientia potestas est*, and you never feel as powerless as when you lose your code.
Thankfully we've worked hard to make saving your work quick and easy.

~~~ bash
$ ./backup.sh GitCERN
~~~

And five minutes later you're back in business and your conscience is at ease!
Restoration is as simple as building another stack, although this time with the `.restore.heat.yml`, and specifying the ID of the backup you want. The new volume size should not be smaller than the original, to avoid loss to data. A list of backups can be found in the « Volume Backups » tab under « Volumes » in the console, or from the command line with the Cinder API:

~~~ bash
$ cinder backup-list

+------+-----------+-----------+-----------------------------------+------+--------------+---------------+
|  ID  | Volume ID |   Status  |                Name               | Size | Object Count |   Container   |
+------+-----------+-----------+-----------------------------------+------+--------------+---------------+
| XXXX | XXXXXXXXX | available | gitlab-backup-2025/10/23-07:27:69 |  10  |     206      | volumebackups |
+------+-----------+-----------+-----------------------------------+------+--------------+---------------+
~~~

Remember however, that while we have greatly simplified the restoration process, your local Git tools will not take into account changes in IP address. SSH Keys will still be valid, but you should make sure to correct any hosts and project remote addresses before continuing your work.

## So watt?

The goal of this tutorial is to accelerate your start. At this point **you** are the master of the stack.

You now have an SSH access point on your virtual machine through the floating IP and your private keypair (default user name `cloud`).

The interesting directories are:

- `/etc/gitlab/gitlab-secrets.json`: Secret tokens, keys, and salts unique to each GitLab
- `/etc/gitlab/gitlab-volume.sh`: Script run upon reboot to remount the volume and verify GitLab is ready to function again
- `/etc/gitlab/gitlab.rb`: Omnibus GitLab's master settings file
- `/etc/gitlab/ssl/`: GitLab's '.key' and '.crt' for HTTPS
- `/var/opt/gitlab/`: GitLab stores all data here, and `/mnt/vdb/gitlab/` is mounted here
- `/dev/vdb`: Volume mount point
- `/mnt/vdb/`: `/dev/vdb` mounted here
- `/mnt/vdb/gitlab/`: Mounts onto `/var/opt/gitlab/` and contains all of GitLab's data
- `/mnt/vdb/gitlab/.gitlab-secrets.json`: Copy of GitLab's secrets in volume for safekeeping and restoration
- `/mnt/vdb/stack_public_entry_point`: Contains last known IP address, used to replace the IP address in all locations when it changes

Other resources you could be interested in:

* [GitLab NGinx Settings](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/629def0a7a26e7c2326566f0758d4a27857b52a3/doc/settings/nginx.md)
* [GitLab Settings Template/Example](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template)
* [Doc for Omnibus GitLab](http://doc.gitlab.com/omnibus/)
* [Doc for GitLab CE](http://doc.gitlab.com/ce/)


-----
Have fun. Hack in peace.
