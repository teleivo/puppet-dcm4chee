#puppet-dcm4chee

[![Build Status](https://secure.travis-ci.org/teleivo/puppet-dcm4chee.png?branch=master)](https://travis-ci.org/teleivo/puppet-dcm4chee)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with dcm4chee](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dcm4chee](#beginning-with-dcm4chee)
4. [Usage - Configuration options](#usage)
    * [I only want a default setup](#i-only-want-a-default-setup)
    * [I want to specify jboss java options](#i-want-to-specify-jboss-java-options)
    * [I want to specify jboss ports](#i-want-to-specify-jboss-ports)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development](#development)

##Overview

The dcm4chee module lets you use Puppet to install, deploy & configure dcm4chee

##Module Description

dcm4chee is an Open Source Clinical Image and Object Management system.
http://www.dcm4che.org/

This module helps you in getting dcm4chee up and running using Puppet.

Following describes the basic building blocks executed by the module:
* staging
    * downloads and extracts all necessary archives for dcm4chee (dcm4chee, jboss,
      java image io library for 64bit machines, DICOM web viewer weasis) into a staging directory
    * executes the dcm4chee install script run.sh
    * copies the weasis war files into dcm4chee's deployment directory
    * exchanges a JAI Image IO library (libclib_jiio.so) for Linux-amd64 see
      http://www.dcm4che.org/confluence/display/ee2/Installation/
    (default staging directory: /opt/dcm4chee/staging)
* installation
    * copies the dcm4chee home path prepared during staging to dcm4chee users home directory
    (default /opt/dcm4chee/staging/dcm4chee-2.18.0-mysql -> /opt/dcm4chee/dcm4chee-2.18.0-mysql)
    * creates a mysql database for dcm4chee and executes the dcm4chee create.mysql script
* configuration
    * configures dcm4chee's mysql connection
    * jboss http and ajp ports and its java opts
    * weasis DICOM connection properties via template files
* service
    * sets up dcm4chee as a service via a template init.d script
    * ensures dcm4chee is running

##Setup

###Setup requirements

The dcm4chee module requires
[nanliu-staging](https://forge.puppetlabs.com/nanliu/staging) version 1.0.3 or newer.
[puppetlabs-mysql](https://forge.puppetlabs.com/puppetlabs/mysql) version 3.1.0 or newer.
To install the modules do:

~~~
puppet module install puppetlabs-mysql
puppet module install nanliu-staging
~~~

**This module expects you to have java already installed.**
**This module expects that you have the packages needed by nanliu-staging (such as unzip, curl) already installed.**

###Beginning with dcm4chee

The simplest way to get dcm4chee up and running with the dcm4chee module is to
install mysql server and dcm4chee on the same node as follows:

```puppet
include 'mysql::server'

class { 'dcm4chee':
    java_path => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
}
```

You can of course install mysql and dcm4chee on different nodes.

##Usage

Following describes basic use cases. Please check out the examples manifests as well.

###I only want a default setup

To setup dcm4chee with its default settings do:

```puppet
class { 'dcm4chee':
    java_path => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
}
```

###I want to specify jboss java options

To specify jboss java options do:

```puppet
class { 'dcm4chee':
    java_path       => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
    jboss_java_opts => [ '-Xms128m',
                         '-Xmx740m',
                         '-XX:MaxPermSize=256m',
                         '-Dsun.rmi.dgc.client.gcInterval=3600000',
                         '-Dsun.rmi.dgc.server.gcInterval=3600000',
    ],
}
```

###I want to specify jboss ports

To specify jboss ports other than the defaults do:

```puppet
class { 'dcm4chee':
    java_path                => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
    jboss_http_port          => 8081,
    jboss_ajp_connector_port => 8089,
}
```

##Limitations

This module was only tested with Ubuntu 14.04 64bit.
This module was only tested with dcm4chee-2.18.0-mysql.
This module is currently limited to dcm4chee using mysql.

##Development

Please feel free to open pull requests!

###Running tests
This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to
verify functionality.

To run the tests:
```bash
gem install bundler
bundle install
bundle exec rake spec
```
