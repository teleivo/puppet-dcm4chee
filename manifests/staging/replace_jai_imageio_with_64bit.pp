class dcm4chee::staging::replace_jai_imageio_with_64bit () {

  $imageio_library_source_name = 'libclib_jiio-1.2-b04-linux-x86-64.so'
  $imageio_library_source_url =
  "http://dicom.vital-it.ch:8087/nexus/content/repositories/releases/org/weasis/thirdparty/com/sun/media/libclib_jiio/1.2-b04/${imageio_library_source_name}"
  $imageio_library_source_path = "${::dcm4chee::staging_path}${imageio_library_source_name}"
  $imageio_library_destination_path = "${::dcm4chee::staging::dcm4chee_home_path}bin/native/libclib_jiio.so"

  ::staging::file { $imageio_library_source_name:
    source => $imageio_library_source_url,
    target => $imageio_library_source_path,
  }->

  file { $imageio_library_destination_path:
    ensure => present,
    owner  => $::dcm4chee::user,
    group  => $::dcm4chee::user,
    source => $imageio_library_source_path,
  }
}
