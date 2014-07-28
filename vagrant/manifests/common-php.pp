$phpExtensionDirectory = '/usr/lib/php5/20121212/'

$fastCgiPort = 9000

Class['::apt::update'] -> Package <|
title != 'python-software-properties'
and title != 'software-properties-common'
|>

apt::key { '4F4EA0AAE5267A6C': }

apt::ppa {
    'ppa:ondrej/php5':
        require => Apt::Key['4F4EA0AAE5267A6C'];
}



# Alternate service to run the software
$phpService = 'php5-fpm'

package {
    [
        'build-essential',
        'vim',
        'curl',
        'git-core',
        'unzip',
        'memcached',
    ]:
        ensure  => 'installed';
}


service {
    'php5-fpm':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Class['php'];
}

class {
    'nginx':;
    'php':
        package             => 'php5-fpm',
        service             => 'php5-fpm',
        service_autorestart => false,
        config_file         => '/etc/php5/fpm/php.ini',
        module_prefix       => '',
        require             => Class['apt'];
    'composer':
        require => [Class['php'], Package['curl']];
}

php::module {
    [
      'php5-cli',
      'php5-curl',
      'php5-intl',
      'php5-xsl',
    ]:
    service => $phpService;
}

class {
    'php::devel':
        require => Class['php'];
}

$phpBackend = "127.0.0.1:${fastCgiPort}"
