# DSpace JRuby

## Installing the [Ruby Version Manager (RVM)](https://rvm.io/)
```bash
dspace@host:~$ gpg \
  --keyserver hkp://pool.sks-keyservers.net \
  --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 \
  7D2BAF1CF37B13E2069D6956105BD0E739499BDB
dspace@host:~$ \curl -sSL https://get.rvm.io | bash -s stable --ruby
```

## Installing [JRuby](https://www.jruby.org/)
```bash
dspace@host:~$ source $HOME/.rvm/scripts/rvm
dspace@host:~$ rvm install jruby-9.2.13.0
dspace@host:~$ rvm use jruby-9.2.13.0
```

## Installing Gem dependencies
```bash
dspace@host:~$ mkdir -p pulibrary-src
dspace@host:~$ cd pulibrary-src
dspace@host:~/pulibrary-src$ git clone https://github.com/pulibrary/dspace-jruby.git
dspace@host:~/pulibrary-src$ cd dspace-jruby
dspace@host:~/pulibrary-src/dspace-jruby$ jgem install bundler
dspace@host:~/pulibrary-src/dspace-jruby$ bundle install
```
