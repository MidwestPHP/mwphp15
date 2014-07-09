# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "puphpet/ubuntu1204-x64"

    config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :create => true, :nfs => true

    config.vm.network :private_network, ip: '192.168.3.40'

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "vagrant/manifests"
        puppet.module_path = "vagrant/modules"
        puppet.manifest_file = "vagrant-php.pp"
        puppet.options = ['--verbose']
    end

    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope       = :box
        config.cache.synced_folder_opts = {
            type: :nfs,
            # The nolock option can be useful for an NFSv3 client that wants to avoid the
            # NLM sideband protocol. Without this option, apt-get might hang if it tries
            # to lock files needed for /var/cache/* operations. All of this can be avoided
            # by using NFSv4 everywhere. Please note that the tcp option is not the default.
            mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
        }
        config.cache.enable :apt
    end
end
