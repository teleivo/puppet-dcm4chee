class dcm4chee::staging::replace_jai_imageio_with_64bit (
) {
    $imageio_archive_base = 'jai_imageio-1_1-lib-linux-amd64'
    $imageio_archive_name = "${imageio_archive_base}.tar.gz"
    $imageio_source_url = "http://download.java.net/media/jai-imageio/builds/release/1.1/${imageio_archive_name}"

    $imageio_filename = 'libclib_jiio.so'
    $imageio_archive_src_location = "jai_imageio-1_1/lib/${imageio_filename}"
    $imageio_archive_destination = "${::dcm4chee::staging::dcm4chee_home_path}bin/native/"

    staging::deploy { $imageio_archive_name:
        source => $imageio_source_url,
        target => $::dcm4chee::staging::path,
        user   => $::dcm4chee::staging::user,
        group  => $::dcm4chee::staging::user,
    }->

    file { "${imageio_archive_destination}${imageio_filename}":
        ensure  => present,
        owner   => $::dcm4chee::staging::user,
        group   => $::dcm4chee::staging::user,
        source  => "${::dcm4chee::staging::path}${imageio_archive_src_location}",
    }
}
