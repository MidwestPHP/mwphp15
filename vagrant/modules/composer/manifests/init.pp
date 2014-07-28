# Class: composer
#
# Installs Composer
class composer (
    $install_location = params_lookup( 'install_location' ),
    $filename         = params_lookup( 'filename' ),
    $download_location = params_lookup( 'download_location' )
) inherits composer::params {

  exec { "curl -sS https://getcomposer.org/installer | php -- --install-dir=${download_location} && mv ${download_location}/composer.phar ${install_location}/${filename}":
    path    => ['/usr/bin', '/bin'],
    creates => "${install_location}/${filename}",
    require => Class['php'],
  }
}
