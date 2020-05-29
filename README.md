# DSpace for Docker and Vagrant

## Prerequisites

### Homebrew (macOS)

Please install [Homebrew](https://brew.sh/), and then please install the following:

```
brew install maven
```

### Docker (macOS)

Please download and install [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/).

## Getting started with Docker

There are a number of options for building the Docker Container and provisioning
the environment. These are ordered with preference for the most expedient
methods:

### Provisioning with a local DSpace build
*Please note that this is the method which is easiest to use for locally
developing and extending DSpace installations run in the container.*

#### Download the release
```bash
cd docker/usr/local/src
wget "https://github.com/DSpace/DSpace/releases/download/dspace-5.3/dspace-5.3-src-release.zip"
unzip dspace-5.3-src-release.zip
cd -
```

#### Build the release
```
cd docker/usr/local/src/dspace-5.3-src-release/dspace
mvn dependency:go-offline
mvn package
cd -
```

#### Run the Container
In one terminal, please run the following, as this will start the DSpace Container:

```
# This is only necessary if you haven't already built the base image
docker build -t pulibrary/dspace-docker-base .
source ./scripts/docker_run_local_storage.sh
```

Then please run the following in a separate terminal to provision the Container:

#### Provision the Container
```
source ./scripts/docker_provision_local_storage.sh
```

Should one wish to start the provisioning from a specific Ansible task, the following can be used:

```
source ./scripts/docker_provision_local_storage.sh --start-at-task="my ansible task"
```

### Provisioning using new DSpace installations

In one terminal, please run the following, as this will start the DSpace Container:

```
# This is only necessary if you haven't already built the base image
docker build -t pulibrary/dspace-docker-base .
source ./scripts/docker_run.sh
```

Then please run the following in a second terminal to provision the Container:

```
source ./scripts/docker_provision.sh
```

## Getting started with Vagrant

### Provisioning the Vagrant Box locally

```bash
vagrant up
vagrant provision
```

## Accessing DSpace

One running, DSpace 5.3 should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using the password `secret`.

## Development

### Initializing the Python environment (for Ansible)

```bash
pyenv local 3.7.7
pip install pipenv
pipenv shell
pipenv sync
```

**Note: In order to deactivate the pipenv `shell`, one must use `exit` (not `deactivate`)**

#### Linting Ansible Roles

```
cd ansible
pipenv run molecule lint
```

#### Testing Ansible Roles

```
cd ansible
pipenv run molecule
```

### Developing locally for Docker

Please use the following in order to actively develop the mvn code base:
```
cd docker/usr/local/src/dspace-5.3-src-release
```

When this is ready for deployment, please use the following to repackage the build and deploy the webapps in the container:
```
mvn package
cd -
source ./scripts/docker_deploy_dspace.sh
```

### Docker Container and Image Management

#### Starting the DSpace container after it has been stopped

```bash
source ./scripts/docker_restart.sh
```

#### Stopping and removing the DSpace container

```bash
docker stop dspace
docker rm dspace
```

#### Clearing the cached image

```bash
docker rmi pulibrary/dspace-docker-base
```

#### Updating the Docker Image for new releases on Docker Hub

```bash
docker commit -a'James Griffin user@email.com' -m'Adding the latest changes to the 1.0.1 release' dspace pulibrary/dspace-docker:1.0.1
docker tag pulibrary/dspace-docker:1.0.1 pulibrary/dspace-docker:latest
docker push pulibrary/dspace-docker:1.0.1
docker push pulibrary/dspace-docker:latest
```

### Developing for JRuby

Please `git clone` the JRuby project into the following directory:
```
cd docker/usr/local/src/jruby-projects
git clone https://github.com/pulibrary/dspace-jruby.git
```

Then, please access the `bash` shell in the container as the user `pulsys`:

```
source ./scripts/docker_shell.sh
```

This will permit one to install the Gems and execute Ruby tasks:

```
pulsys@1ee4c7a8cfb3:/$ cd /usr/local/src/jruby-projects/dspace-jruby
pulsys@1ee4c7a8cfb3:/usr/local/src/dspace-jruby$ bundle install --path vendor/bundle
pulsys@1ee4c7a8cfb3:/usr/local/src/dspace-jruby$ bundle exec yardoc
```

#### Working with Interactive Ruby (IRB)

```
pulsys@1ee4c7a8cfb3:/usr/local/src/dspace-jruby$ irb -I /usr/local/src/jruby-projects/dspace-jruby/lib
```

For convenience, the following aliases can be introduced:
```
alias irbd="irb -I /usr/local/src/jruby-projects/dspace-jruby/lib -I /usr/local/src/jruby-projects/dspace-cli"
alias jrubyd="jruby -I /usr/local/src/jruby-projects/dspace-jruby/lib -I /usr/local/src/jruby-projects/dspace-cli"
```

```ruby
irb(main):001:0> require 'dspace'
=> true
irb(main):002:0> DSpace.load
Using /dspace
Loading jars
Loading /dspace/config/dspace.cfg
INFO: Loading provided config file: /dspace/config/dspace.cfg
INFO: Using dspace provided log configuration (log.init.config)
INFO: Loading: /dspace/config/log4j.properties
Starting new DSpaceKernel
DB jdbc:postgresql://localhost:5432/dspace, UserName=dspace, PostgreSQL Native Driver
=> true
irb(main):003:0> DSpace.login('admin@localhost')
=> nil
irb(main):004:0> person = DEPerson.find('admin@localhost')
=> #<Java::OrgDspaceEperson::EPerson:0x6dca31eb>
```
