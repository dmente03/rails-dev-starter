# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = 'rails-dev-starter'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  #config.vm.network "private_network", ip: "192.168.0.99"

  config.vm.provision :shell, :path => "puppet/bootstrap.sh"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "init.pp"
    puppet.module_path = "modules"
  end

  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
