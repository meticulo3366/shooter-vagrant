#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export TOUCH_FILE=/.provisioned
export GO_URL=https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz

if [ ! -f $TOUCH_FILE ]; then

  # For nginx > 1.3
  echo "deb http://nginx.org/packages/ubuntu/ precise nginx" | tee /etc/apt/sources.list.d/nginx.list

  # Updating system.
  apt-get update
  apt-get upgrade -y

  # Installing required packages.
  apt-get install -y vim bzr git make curl
  curl http://nginx.org/keys/nginx_signing.key | apt-key add -

  apt-get install -y nginx

  # Getting MongoDB
  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
  apt-get update
  apt-get install mongodb-org -y

  # Getting Go.
  if [ ! -d /usr/local/go ]; then
    rm -f /tmp/go.tar.gz;
    echo "Downloading Go...";
    wget -q $GO_URL -O /tmp/go.tar.gz &&
    mkdir -p /usr/local/ &&
    tar xzf /tmp/go.tar.gz -C /usr/local/;
  fi;

  touch $TOUCH_FILE
fi

# Copying configuration files.
cp -r /vagrant/etc/* /etc;
cp /vagrant/.bashrc /home/vagrant/.bashrc;

# Restarting services.
service mongod restart
service nginx restart

# Getting shooter-server.
if [ ! -d /vagrant/shooter-server ]; then
sudo -s -H -u vagrant /bin/bash - << eof
  source \$HOME/.bashrc;
  git clone https://github.com/xiam/shooter-server.git /vagrant/shooter-server;
  cd /vagrant/shooter-server;
  make;
  cd src;
  go get -d;
  make;
eof
fi

# Getting shooter-html5's experimental branch.
if [ ! -d /vagrant/shooter-html5 ]; then
sudo -s -H -u vagrant /bin/bash - << eof
  source \$HOME/.bashrc;
  git clone https://github.com/xiam/shooter-html5.git /vagrant/shooter-html5;
  cd /vagrant/shooter-html5;
  git pull -a;
  git checkout -b experimental remotes/origin/experimental;
eof
fi


# Starting shooter-server.
sudo -s -H -u vagrant /bin/bash - << eof
  cd /vagrant/shooter-server/src;
  MONGO_HOST="127.0.0.1" ./shooter-server -listen 0.0.0.0:3223;
eof
