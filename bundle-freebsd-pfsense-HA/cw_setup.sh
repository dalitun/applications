#!/usr/local/bin/php -f
<?php

# PROVIDE: cw_setup
### Written by the CAT (Cloudwatt Automation Team)
#/usr/local/etc/rc.d/cw_setup.sh
require("globals.inc");
require("config.inc");
require("auth.inc");
require("interfaces.inc");
require_once("functions.inc");
require_once("filter.inc");

function retrieveMetaData($url) {

        if (!$url)
                return;

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_FAILONERROR, true);
        curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 15);
        curl_setopt($curl, CURLOPT_TIMEOUT, 30);
        $metadata = curl_exec($curl);
        curl_close($curl);

        return($metadata);
}


function addSSHkey(){

$key=retrieveMetaData("http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key");
shell_exec ('echo "' . $key .'">>~/.ssh/authorized_keys');

}
####main#################################

$config['system']['hostname'] = 'master';
$config['system']['domain'] = 'localdomain';
$config['system']['dnsserver']['0'] = '8.8.8.8';
$config['system']['dnsserver']['1'] = '8.8.4.4';

$config['interfaces']['wan']['enable'] = 'true';
$config['interfaces']['wan']['if'] = 'em0';
$config['interfaces']['wan']['descr'] = 'WAN';
$config['interfaces']['wan']['ipaddr'] = 'dhcp';

$tmp=retrieveMetaData("http://169.254.169.254/openstack/latest/user_data");
parse_str($tmp);
parse_config(true);
if($config['interfaces']['lan']['ipaddr'] != $ip_lan)
{

addSSHkey();
#retrievePublicIP();


$config['interfaces']['lan']['enable'] = 'true';
$config['interfaces']['lan']['if'] = 'em1';
$config['interfaces']['lan']['descr'] = 'LAN';
$config['interfaces']['lan']['ipaddr'] = '172.16.0.2';
$config['interfaces']['lan']['subnet'] = '24';
$config['interfaces']['pfsync']['enable'] = 'true';
$config['interfaces']['pfsync']['if'] = 'em2';
$config['interfaces']['pfsync']['descr'] = 'PFSYNC';
$config['interfaces']['pfsync']['ipaddr'] = '192.168.254.1';
$config['interfaces']['pfsync']['subnet'] = '29';
$config['interfaces']['lan']['enable'] = true;
$config['interfaces']['lan']['ipaddr']= $ip_lan;
$config['interfaces']['lan']['subnet']= $netmask;
$config['dhcpd']['lan']['enable'] = true;
$config['dhcpd']['lan']['range']['from']=$dhcp_to;
$config['dhcpd']['lan']['range']['to']=$dhcp_from;
###conf synnc interface



	/* to save out the new configuration (config.xml) */
	write_config();
  log_error("rc.reload_all: Reloading all configuration settings.");
  shell_exec('/etc/rc.reload_all');
  wait(10);
 #shell_exec('pfSsh.php playback enableallowallwan');
  shell_exec('/etc/rc.initial');
}

else

  echo('This configuration is already existed');

?>
