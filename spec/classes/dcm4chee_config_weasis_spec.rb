require 'spec_helper'

describe 'dcm4chee::config::weasis', :type => :class do
  
  { 'mysql' => 'mysql', 'postgresql' => 'psql' }.each do |database_type, database_type_short|
    describe "with defaults, server_java_path set and database_type=#{database_type}" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type    => #{database_type}, 
           server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }"
      end

      it { is_expected.to contain_file("/opt/dcm4chee/dcm4chee-2.18.1-#{database_type_short}/server/default/conf/weasis-pacs-connector.properties")
            .with({
              'ensure'  => 'file',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'mode'    => '0644',
            })
            .with_content(/^aet=PACS-CONNECTOR$/)
            .with_content(/^pacs.aet=DCM4CHEE$/)
            .with_content(/^pacs.host=localhost$/)
            .with_content(/^pacs.port=11112$/)
            .with_content(/^request.ids=patientID,studyUID,accessionNumber,seriesUID,objectUID$/)
            .with_content(/^hosts.allow=$/)
      }
    end

    describe "with database_type=#{database_type} and custom server parameters" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type      => #{database_type},
           server_java_path   => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
           server_host        => '192.168.1.11',
           server_dicom_aet   => 'MEDPACS',
           server_dicom_port  => '104',
           weasis_aet         => 'WEASIS',
           weasis_request_ids => [ 'patientID', 'studyUID' ],
           weasis_hosts_allow => [ '192.168.1.20', '192.168.1.21' ],
        }"
      end

      it { is_expected.to contain_file("/opt/dcm4chee/dcm4chee-2.18.1-#{database_type_short}/server/default/conf/weasis-pacs-connector.properties")
            .with({
              'ensure'  => 'file',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'mode'    => '0644',
            })
            .with_content(/^aet=WEASIS$/)
            .with_content(/^pacs.aet=MEDPACS$/)
            .with_content(/^pacs.host=192.168.1.11$/)
            .with_content(/^pacs.port=104$/)
            .with_content(/^request.ids=patientID,studyUID$/)
            .with_content(/^hosts.allow=192.168.1.20,192.168.1.21$/)
      }
    end
  end
end

