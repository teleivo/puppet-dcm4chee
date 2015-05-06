#puppet-dcm4chee

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
2. [Usage](#usage)
    * [I only want to execute the staging part](#i-only-want-to-execute-the-staging-part)
    * [I only want to execute the installation and configuration part](#i-only-want-to-execute-the-installation-and-configuration-part)
    * [I want to execute staging, installation and configuration together](#i-want-to-execute-staging-installation-and-configuration-together)
3. [Limitations - OS compatibility, etc.](#limitations)
4. [Contributions](#contributions)

##Overview

The dcm4chee module lets you use Puppet to install, deploy & configure dcm4chee

##Module Description

dcm4chee is an Open Source Clinical Image and Object Management system.
http://www.dcm4che.org/

This module helps you in getting dcm4chee up and running using Puppet.

The installation is basically split into two parts:
* staging
    * downloads and extracts all necessary archives for dcm4chee (dcm4chee, jboss,
      java image io library for 64bit machines, DICOM web viewer weasis) into a staging directory
    * executes the dcm4chee install script run.sh
    * installs mysql server, creates a mysql database for dcm4chee and executes the dcm4chee create.mysql
      script
    * copies the weasis war files into dcm4chee's deployment directory
    * exchanges a JAI Image IO library (libclib_jiio.so) for Linux-amd64 see
      http://www.dcm4che.org/confluence/display/ee2/Installation/
* installation, configuration
    * copies the dcm4chee home path prepared during staging to dcm4chee users
      home directory
    * configures dcm4chee's mysql connection, jboss http and ajp ports and its
      java opts, weasis DICOM connection properties via template files
    * sets up dcm4chee as a service and starts dcm4chee

##Usage

###I only want to execute the staging part

To create the staging directory with all dcm4chee files in places and the
mysql database set up:

```puppet
class { 'dcm4chee::staging':
}
```

###I only want to execute the installation and configuration part

If you already executed the staging part you can install and configure dcm4chee
with:

```puppet
class { 'dcm4chee':
    java_path                => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
    jboss_http_port          => 8081,
    jboss_ajp_connector_port => 8089,
    jboss_java_opts          => [ '-Xms128m',
                                  '-Xmx740m',
                                  '-XX:MaxPermSize=256m',
                                  '-Dsun.rmi.dgc.client.gcInterval=3600000',
                                  '-Dsun.rmi.dgc.server.gcInterval=3600000',
    ],
}
```

Note that this assumes that the dcm4chee staging directory is at its default
location. Please check the default path in params.pp

###I want to execute staging, installation and configuration together

To execute staging, installation and configuration together do:

```puppet
class { 'dcm4chee':
    java_path                => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
    execute_staging          => 'true',
    jboss_http_port          => 8081,
    jboss_ajp_connector_port => 8089,
    jboss_java_opts          => [ '-Xms128m',
                                  '-Xmx740m',
                                  '-XX:MaxPermSize=256m',
                                  '-Dsun.rmi.dgc.client.gcInterval=3600000',
                                  '-Dsun.rmi.dgc.server.gcInterval=3600000',
    ],
}
```

##Limitations

This module was only tested with Ubuntu 14.04 64bit.
This module is currently limited to dcm4chee using mysql.

##Contributions

Contributions are very welcome :)
