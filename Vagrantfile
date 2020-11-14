# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"

  config.ssh.compression = true
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = false

  config.vm.network "forwarded_port", guest: 4444, host: 4444

  config.vm.synced_folder "./", "/data",
    :owner => 'vagrant',
    :group => 'vagrant',
    :mount_options => ['dmode=775', 'fmode=775']

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
  end

  config.vm.provision "file", source: "pacman.conf", destination: "/tmp/pacman.conf"

  config.vm.provision "shell", path: "install.sh", privileged: false
  config.vm.provision "file", source: "./src/.zshrc", destination: "~/.zshrc"
  config.vm.provision "file", source: "./src/.tmux.conf", destination: "~/.tmux.conf"
  config.vm.provision "file", source: "./src/.vimrc", destination: "~/.vimrc"
  config.vm.provision "file", source: "./src/.config", destination: "~/.config"
end
