import "common.pp"
import "common-php.pp"

$phpServiceWebPath = '/usr/share'
$composerPath = '/var/www/'

$pathInfo = '$fastcgi_path_info'
$scriptName = '$fastcgi_script_name'

# Development Environment get XDebug

$enableDebug = false

$xDebugProfilerEnabled = $enableDebug ? {
    true => 1,
    default => 0
}

php::module {
    [
        'php5-xdebug',
    ]:
        service => $phpService;
}

class {
    ['dotfiles']:;
}

nginx::resource::vhost {

    'primary':
        ensure          => present,
        server_name     => [
            '192.168.3.40',
            '127.0.0.1',
            '*.vagrantshare.com'
        ],
        use_default_location => true,
        www_root        => '/var/www/output_vagrant/',
        listen_port     => 80,
        index_files     => false,
        notify          => Class['nginx::service'];
}

exec {
    "sculpin-phar-install":
        command => "curl -O https://download.sculpin.io/sculpin.phar && mv sculpin.phar /usr/bin/sculpin && chmod 777 /usr/bin/sculpin",
        path    => ['/usr/bin', '/bin'],
        creates => "/usr/bin/sculpin",
        require => Class['php'];

    "sculpin-install":
        command => "sculpin install",
        cwd     => '/var/www/',
        path    => ['/usr/bin', '/bin'],
        creates => "/var/www/.sculpin",
        require => Exec['sculpin-phar-install'];

    'sass_install':
        command => "gem install sass && touch $puppet_lock_dir/sass_install",
        creates => "$puppet_lock_dir/sass_install",
        require => [
            Package['ruby-full', 'rubygems1.8'],
        ];

    'compass_install':
        command => "gem install compass && touch $puppet_lock_dir/compass_install",
        creates => "$puppet_lock_dir/compass_install",
        require => [
            Exec['sass_install'],
        ];
}



supervisor::program {
    'sculpin-generator':
        ensure      => present,
        autorestart => true,
        enable      => true,
        numprocs    => 1,
        command     => 'sculpin generate --watch --env=vagrant',
        directory   => '/var/www',
        user        => 'www-data',
        group       => 'www-data',
        require     => Exec['sculpin-phar-install', 'sculpin-install'];

    'compass-watcher':
        ensure      => present,
        autorestart => true,
        enable      => true,
        numprocs    => 1,
        command     => 'compass watch',
        directory   => '/var/www/source/themes/midwestphp/mwphp15-theme',
        user        => 'www-data',
        group       => 'www-data',
        require     => Exec['compass_install', 'sculpin-install'];
}
