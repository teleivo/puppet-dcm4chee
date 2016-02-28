#puppet-dcm4chee

[![Build Status](https://secure.travis-ci.org/teleivo/puppet-dcm4chee.png?branch=master)](https://travis-ci.org/teleivo/puppet-dcm4chee)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with dcm4chee](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dcm4chee](#beginning-with-dcm4chee)
4. [Usage - Configuration options](#usage)
    * [I only want a default setup](#i-only-want-a-default-setup)
    * [I want to specify jboss java options](#i-want-to-specify-jboss-java-options)
    * [I want to specify jboss ports](#i-want-to-specify-jboss-ports)
    * [I want to install dcm4chee database and server on different nodes](#i-want-to-install-dcm4chee-database-and-server-on-different-nodes)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Parameters](#parameters)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development](#development)

## Overview

The dcm4chee module lets you use Puppet to install, deploy & configure [dcm4chee](http://www.dcm4che.org/) and [weasis](https://github.com/nroduit/Weasis).

## Module Description

dcm4chee is an Open Source Clinical Image and Object Management system.
http://www.dcm4che.org/

weasis is an Open Source DICOM web viewer. https://github.com/nroduit/Weasis

This module helps you in getting both set up and running using Puppet.

Following describes the basic building blocks executed by the module:
* staging
    * downloads and extracts all necessary archives for dcm4chee (dcm4chee, jboss,
      java image io library for 64bit machines, weasis) into a staging directory
    * executes install_jboss.sh to copy jboss components over to dcm4chee
    * exchanges a JAI Image IO library (libclib_jiio.so) for Linux-amd64 see
      [dcm4chee install-guide](http://www.dcm4che.org/confluence/display/ee2/Installation/)
    * copies weasis, weasis-pacs-connector, weasis-i18n war files into dcm4chee's deployment directory
* installation
    * copies the dcm4chee home path prepared during staging to dcm4chee users home directory
    * installs a database server, creates a database for dcm4chee and executes the dcm4chee database creation script
* configuration
    * configures dcm4chee's database connection
    * configures jboss http and ajp ports and its java command line arguments
    * configures weasis using weasis [pacs-connector](https://github.com/nroduit/weasis-pacs-connector)
* service
    * sets up dcm4chee as a service via a template init.d script
    * ensures dcm4chee is running

## Setup

### Setup requirements

Please refer to the dependency section in [metadata.json](metadata.json) for the pre-requisite modules.

**Important note: this module expects**
 * you to have java already installed
 * you to have packages needed by nanliu-staging (such as unzip, curl) already installed

### Beginning with dcm4chee

The simplest way to get dcm4chee up and running with the dcm4chee module is to
install dcm4chee database and server on the same node as follows:

```puppet
class { 'dcm4chee':
    server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
}
```

## Usage

Following describes basic use cases. Please check out the examples manifests as well.

### I only want a default setup

To setup dcm4chee with its default settings do:

```puppet
class { 'dcm4chee':
    server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
}
```

### I want to specify jboss java options

To specify jboss java options do:

```puppet
class { 'dcm4chee':
    server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
    server_java_opts => [ '-Xms128m',
                          '-Xmx740m',
                          '-XX:MaxPermSize=256m',
                          '-Dsun.rmi.dgc.client.gcInterval=3600000',
                          '-Dsun.rmi.dgc.server.gcInterval=3600000',
    ],
}
```

### I want to specify jboss ports

To specify jboss ports other than the defaults do:

```puppet
class { 'dcm4chee':
    server_java_path          => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
    server_http_port          => 8081,
    server_ajp_connector_port => 8089,
}
```

### I want to install dcm4chee database and server on different nodes

To install dcm4chee database and server on separate nodes using [roles and profiles pattern](http://garylarizza.com/blog/2014/02/17/puppet-workflow-part-2/)

```puppet
node 'db.example.com' {
   include role::db
}

class role::db { 

   class { 'dcm4chee':
      server      => false,
      server_host => 'pacs.example.com', 
   }
}

node 'pacs.example.com' {
   include role::pacs
}

class role::pacs { 

   class { 'dcm4chee':
      server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
      database         => false,
      database_host    => 'db.example.com',
   }
}
```

*Note:* you need to add necessary puppet code to above example code to ensure database connectivity between dcm4chee database and server.

## Reference

### Classes

#### Public classes

* [`dcm4chee`](#dcm4chee): Installs and configures dcm4chee.

#### Private classes

### Parameters

All parameters are optional except where otherwise noted.

#### dcm4chee

##### `server`

Specifies whether the dcm4chee server should be installed.
Valid options: 'true', 'false'.
Defaults to 'true'.

##### `server_version`

Specifies the dcm4chee version which should be installed.
Valid options: '2.18.1'.
Defaults to '2.18.1'.

##### `server_host`

Specifies the dcm4chee host name or IP address.
Valid options: string.
Defaults to 'localhost'.

##### `server_java_path`

Specifies the absolute path to the java binary which should be used to run dcm4chee.
Valid options: string containing an absolute path.
Default is undefined. You must define this parameter if `server` = true.

##### `server_java_opts`

Specifies the java command line arguments which should be used to run dcm4chee (see [template](templates/dcm4chee_home/bin/run.conf.erb)).
Valid options: an array.
Default is [].

##### `server_http_port`

Specifies the dcm4chee (jboss) http port.
Valid options: integer between 0 and 65535.
Defaults to '8080'.

##### `server_ajp_connector_port`

Specifies the dcm4chee (jboss) ajp connector port.
Valid options: integer between 0 and 65535.
Defaults to '8009'.

##### `server_log_file_path`

Specifies the dcm4chee (jboss) log file path managing 'server/default/conf/jboss-log4j.xml' RollingFileAppender param "File".
Valid options: string.
Defaults to '${jboss.server.log.dir}/server.log'.

##### `server_log_file_max_size`

Specifies the dcm4chee (jboss) log file max size managing 'server/default/conf/jboss-log4j.xml' RollingFileAppender param "MaxFileSize".
Valid options: string.
Defaults to '10000KB'.

##### `server_log_append`

Specifies whether the dcm4chee dcm4chee (jboss) log file should be appended to. Managing 'server/default/conf/jboss-log4j.xml' RollingFileAppender param "Append".
Valid options: 'true', 'false'.
Defaults to 'false'.

##### `server_log_max_backups`

Specifies the dcm4chee (jboss) log file path managing 'server/default/conf/jboss-log4j.xml' RollingFileAppender param "MaxBackupIndex".
Valid options: integer.
Defaults to '1'.

##### `server_log_appenders`

Specifies the dcm4chee (jboss) log appenders managing 'server/default/conf/jboss-log4j.xml' <root> <appender-ref> elements.
Valid options: array containing elements from values 'FILE', 'CONSOLE', 'JMX'.
Defaults to [ 'FILE', 'JMX' ].

##### `server_dicom_aet`

Specifies the dcm4chee DICOM AE Title.
Valid options: string.
Defaults to 'DCM4CHEE'.
*Important note:* this parameter is only used to configure the connection of DICOM web viewer `weasis` to dcm4chee.
It does not change dcm4chee's DICOM AE Title. This should be done from within dcm4chee's web UI!

##### `server_dicom_port`

Specifies the dcm4chee DICOM port.
Valid options: integer between 0 and 65535.
Defaults to '11112'.
*Important note:* this parameter is only used to configure the connection of DICOM web viewer `weasis` to dcm4chee.
It does not change dcm4chee's DICOM AE Title. This should be done from within dcm4chee's web UI!

##### `server_dicom_compression`

Specifies whether JAI Image IO library (libclib_jiio.so) for Linux-amd64 should be exchanged.
Valid options: 'true', 'false'.
Defaults to 'false'.

##### `manage_user`

Determines whether to create the specified `user`, if it doesn't exist. Uses Puppet's native [`user` resource type](https://docs.puppetlabs.com/references/latest/type.html#user) with parameters `managehome` => true, `home` => `$::dcm4chee::user_home`. Valid options: 'true' and 'false'. Default: 'true'.

#####`user`

Specifies a user to run dcm4chee as. Is passed to Puppet's native [`user` resource type](https://docs.puppetlabs.com/references/latest/type.html#user) parameter `name`.
Valid options: string containing a valid username.
Default: 'dcm4chee'.

#####`user_home`

Specifies home directory of `user`.
Valid options: string containing an absolute path. Is passed to Puppet's native [`user` resource type](https://docs.puppetlabs.com/references/latest/type.html#user) parameter `home`.
Default: '/opt/dcm4chee'.

##### `database`

Specifies whether the dcm4chee database should be installed.
Valid options: 'true', 'false'.
Defaults to 'true'.

##### `database_type`

Specifies the type of the dcm4chee database.
Valid options: 'mysql', 'postgresql'.
Defaults to 'postgresql'.

##### `database_host`

Specifies the dcm4chee database host name or IP address.
Valid options: string.
Defaults to 'localhost'.

##### `database_port`

Specifies the dcm4chee database port.
Valid options: integer between 0 and 65535.
Defaults to '5432' for `database_type` = 'postgresql' and '3306' for `database_type` = 'mysql'.

##### `database_name`

Specifies the dcm4chee database to create.
Valid options: string.
Defaults to 'dcm4chee'.

##### `database_owner_password`

Specifies the dcm4chee database owners password.
Valid options: string.
Defaults to 'dcm4chee'.

##### `weasis`

Specifies whether the DICOM web viewer [weasis](https://github.com/nroduit/Weasis) should be installed.
Valid options: 'true', 'false'.
Defaults to 'true'.

##### `weasis_aet`

Specifies the weasis [pacs-connector](https://github.com/nroduit/weasis-pacs-connector) property 'aet'.
Valid options: string.
Defaults to 'PACS-CONNECTOR'.

##### `weasis_request_addparams`

Specifies the weasis [pacs-connector](https://github.com/nroduit/weasis-pacs-connector) property 'request.addparams'.
Valid options: string.
Default is undefined.

##### `weasis_request_ids`

Specifies the weasis [pacs-connector](https://github.com/nroduit/weasis-pacs-connector) property 'request.ids'.
Valid options: an array containing elements from values 'patientID', 'studyUID', 'accessionNumber', 'seriesUID', 'objectUID'.
Defaults to [ 'patientID', 'studyUID', 'accessionNumber', 'seriesUID', 'objectUID' ].

##### `weasis_hosts_allow`

Specifies the weasis [pacs-connector](https://github.com/nroduit/weasis-pacs-connector) property 'hosts.allow'.
Valid options: an array.
Default is [].

##Limitations

This module was only tested with dcm4chee-2.18.1-psql and dcm4chee-2.18.1-mysql.

This module is currently limited to Ubuntu 14.04 64bit.

This module is currently limited to dcm4chee version 2.18.1.


##Development

Please feel free to open pull requests!

###Running tests
This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to
verify functionality.

To install all dependencies for the testing environment:
```bash
sudo gem install bundler
bundle install
```

To run the tests once:
```bash
bundle exec rake spec
```

To run the tests on any change of puppet files in the manifests folder:
```bash
bundle exec guard
```
