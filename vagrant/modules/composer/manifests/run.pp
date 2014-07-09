define composer::run (
  $path,
  $creates = false,
  $command = 'install',
  $user = 'vagrant',
  $group = 'vagrant',
) {

    include composer

    if $creates {
        exec { "${composer::filename} ${command} --working-dir ${path} -v -n":
            environment => ["COMPOSER_HOME=/home/${user}/.composer/", "HOME=${user}"],
            logoutput   => 'on_failure',
            creates     => $creates,
            path        => ['/usr/bin', '/bin', $composer::install_location],
            require     => Class['php'],
            user        => $user,
            group       => $group
        }
    }
    else
    {
        exec { "${composer::filename} ${command} --working-dir ${path} -v  -n":
            environment => ["COMPOSER_HOME=/home/${user}/.composer/", "HOME=${user}"],
            logoutput   => 'on_failure',
            path        => ['/usr/bin', '/bin', $composer::install_location],
            require     => Class['php'],
            user        => $user,
            group       => $group
        }
    }
}
