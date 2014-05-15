Vagrant.configure("2") do |config|
  config.vm.box = "shooter-io"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "10.2.2.10"

  config.ssh.forward_agent = true

  config.vm.provision :shell, :path => "./bootstrap.sh"
end
