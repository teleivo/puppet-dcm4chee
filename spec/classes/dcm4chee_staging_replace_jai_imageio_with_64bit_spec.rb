require 'spec_helper'

describe 'dcm4chee::staging::replace_jai_imageio_with_64bit', :type => :class do
  
  { 'mysql' => 'mysql', 'postgresql' => 'psql' }.each do |database_type, database_type_short|
    describe "with defaults, server_java_path set and database_type=#{database_type}" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type    => #{database_type}, 
           server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }"
      end

      it { is_expected.to contain_staging__file('libclib_jiio-1.2-b04-linux-x86-64.so')
            .with({
              'source'  => 'http://dicom.vital-it.ch:8087/nexus/content/repositories/releases/org/weasis/thirdparty/com/sun/media/libclib_jiio/1.2-b04/libclib_jiio-1.2-b04-linux-x86-64.so',
              'target'  => '/opt/dcm4chee/staging/libclib_jiio-1.2-b04-linux-x86-64.so',
            })
            .that_comes_before("File[/opt/dcm4chee/staging/dcm4chee-2.18.0-#{database_type_short}/bin/native/libclib_jiio.so]")
      }
      it { is_expected.to contain_file("/opt/dcm4chee/staging/dcm4chee-2.18.0-#{database_type_short}/bin/native/libclib_jiio.so")
            .with({
              'ensure'  => 'file',
              'owner'   => 'dcm4chee',
              'source'  => '/opt/dcm4chee/staging/libclib_jiio-1.2-b04-linux-x86-64.so',
            })
      }
    end
  end
end

