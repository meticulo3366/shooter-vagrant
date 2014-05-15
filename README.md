# Vagrantfile for upper.io/db

This is a virtual environment for running a local [shooter.io][1] server and
client.

```
git clone https://github.com/xiam/shooter-vagrant.git
cd shooter-vagrant
vagrant up
```

After first boot, start the machine with

```
vagrant up --provision
```

or

```
vagrant up
vagrant provision
```

A web server will listen on `10.2.2.10`, as defined on `Vagrantfile`.

```
  config.vm.network :private_network, ip: "10.2.2.10"
```

Open http://10.2.2.10 with a web browser to see the [shooter-html5][3] client
running against a local `shooter-server`.

[1]: http://shooter.io
[2]: https://github.com/xiam/shooter-server
[3]: https://github.com/xiam/shooter-html5
