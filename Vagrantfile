# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
    v.name = "3kworkshop"
  end

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.hostname = "3kworkshop"

  config.vm.network "private_network", ip: "10.0.201.80"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.synced_folder './', '/vagrant', id: '3kworkshop', type: "nfs"

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "etc/provisioning/setup.yml"
    ansible.groups = {
      "vagrant" => ["default"],
      "servers:children" => ["vagrant"]
    }
    ansible.extra_vars = {
      "private_ip" => "127.0.0.1"
    }
    ansible.verbose = true
    ansible.limit = 'all'
  end
end
