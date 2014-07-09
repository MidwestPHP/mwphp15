group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

$puppet_lock_dir = '/var/puppet_locks/'

file {
    "/etc/localtime":
        ensure => "/usr/share/zoneinfo/CST6CDT";
    "/etc/timezone":
        content => "CST6CDT\n";
    "/etc/default/locale":
        content => "LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"\n";
    $puppet_lock_dir:
        ensure => 'directory',
        owner => "root",
        group => "root";
}

class {
    'apt':
        always_apt_update => true;
    'concat::setup':
}

package {
    [
        'nano',
        'sysstat',
        'ruby-full',
        'rubygems1.8'
    ]:
        ensure  => 'installed';
}
