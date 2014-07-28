class dotfiles::config {
    $command_files = [
        '.git-commands',
        '.mysql-commands',
        #'.symphony-commands'
    ]

    case $operatingsystem {
        'Solaris':          { $distro_file = '.empty'  }
        'RedHat', 'CentOS': { $distro_file = '.empty'   }
        /^(Debian|Ubuntu)$/:{ $distro_file = '.ubuntu' }
        default:            { $distro_file = '.empty'  }
    }
}