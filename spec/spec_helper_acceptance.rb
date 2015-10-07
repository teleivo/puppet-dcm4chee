require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = [ 'Windows', 'Solaris', 'AIX', 'Suse', 'RedHat' ]

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'dcm4chee')
    hosts.each do |host|
      # Required for binding tests.
      on host, puppet('module','install','spantree-java7','--version','0.3.1')
      on host, puppet('module','install','puppetlabs-stdlib','--version','4.9.0')
      on host, puppet('module','install','nanliu-staging','--version','1.0.3')
      on host, puppet('module','install','puppetlabs-mysql','--version','3.6.1')

      pp = <<-EOS
        package { [ 'unzip', 'curl', 'python-software-properties', 'software-properties-common' ]: }

        include 'mysql::server'
      EOS
      on host, apply_manifest(pp), { :catch_failures => false }
      # need to apply the following manifest twice because of issue with
      # apt-get update not being called right after apt-add-repository
      pp = <<-EOS
        include 'java7'
      EOS
      on host, apply_manifest(pp), { :catch_failures => false }
      on host, apply_manifest(pp), { :catch_failures => false }
    end
  end
end
