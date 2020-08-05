
# Open Access Repository

## Server Authentication

```
export BASTION_HOST=epoxy.princeton.edu
export DSPACE_USER=pulsys
export DSPACE_HOST=oar-dev.princeton.edu
source scripts/login.sh
sudo su -
tmux attach-session -t root || tmux new-session -s root
sudo su - dspace
```

## 

## Installing `dspace-jruby` and `dspace-cli`

```
mkdir -p $HOME/src/ruby
git clone https://github.com/pulibrary/dspace-jruby.git
git clone https://github.com/pulibrary/dspace-cli.git cli
```

## Interactive Ruby (REPL) for dspace-jruby

```
bin/dspace-jruby ruby/bin/dspacerb
```

This should log the following:

```
Using /dspace
Loading jars
Loading /dspace/config/dspace.cfg
INFO: Loading provided config file: /dspace/config/dspace.cfg
INFO: Using dspace provided log configuration (log.init.config)
INFO: Loading: /dspace/config/log4j.properties
Starting new DSpaceKernel
irb(main):001:0>
```
