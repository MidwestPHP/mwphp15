class dotfiles {

    include dotfiles::config

    # Basic file configuration
    file {
        '/home/vagrant/.bash_aliases':
            ensure => directory,
            mode => 0750,
            owner => 'vagrant',
            group => 'vagrant',
            source => "puppet:///modules/dotfiles/.bash_aliases";

        '/home/vagrant/.command-files':
            ensure => directory,
            mode => 0660,
            owner => 'vagrant',
            group => 'vagrant';

        '/home/vagrant/.distro-file':
            mode => 0750,
            owner => 'vagrant',
            group => 'vagrant',
            source => "puppet:///modules/dotfiles/.distro-specific/$dotfiles::config::distro_file";

        '/home/vagrant/.git-prompt.sh':
            mode => 0750,
            owner => 'vagrant',
            group => 'vagrant',
            source => "puppet:///modules/dotfiles/.git-prompt.sh";

    }

    # Load up all of the dotfiles
    commandFiles{ $dotfiles::config::command_files: }
}

define commandFiles {
    file { "/home/vagrant/.command-files/$name":
        ensure => present,
        mode => 0750,
        require => File['/home/vagrant/.command-files'],
        source => "puppet:///modules/dotfiles/.command-files/$name",
        owner => 'vagrant',
        group => 'vagrant';
    }
}