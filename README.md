# DSpace for Docker and Vagrant

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
docker build -t jrgriffiniii/dspace-docker-base .
source ./scripts/docker_run_local_storage.sh
```

Then please run the following in a separate terminal to provision the Container:

#### Provision the Container
```
source ./scripts/docker_provision_local_storage.sh
```

### Provisioning using new DSpace installations

In one terminal, please run the following, as this will start the DSpace Container:

```
# This is only necessary if you haven't already built the base image
docker build -t jrgriffiniii/dspace-docker-base .
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

#### Stopping and removing the DSpace container

```bash
docker stop dspace
docker rm dspace
```

#### Clearing the cached image

```bash
docker rmi jrgriffiniii/dspace-docker-base
```

#### Updating the Docker Image for new releases on Docker Hub

```bash
docker commit -a'James Griffin jrgriffiniii@gmail.com' -m'Adding the latest changes to the 1.0.1 release' dspace jrgriffiniii/dspace-docker:1.0.1
docker tag jrgriffiniii/dspace-docker:1.0.1 jrgriffiniii/dspace-docker:latest
docker push jrgriffiniii/dspace-docker:1.0.1
docker push jrgriffiniii/dspace-docker:latest
```

### Developing for JRuby

Please `git clone` the JRuby project into the following directory:
```
cd docker/usr/local/src/jruby-projects
git clone https://github.com/pulibrary/dspace-jruby.git
```

Then, please access the `bash` shell in the container as the user `pulsys`:

```
docker exec -it --user=pulsys dspace bash -l
```

This will permit one to install the Gems and execute Ruby tasks:

```
pulsys@1ee4c7a8cfb3:/$ cd /usr/local/src/jruby-projects/dspace-jruby
pulsys@1ee4c7a8cfb3:/usr/local/src/dspace-jruby$ bundle install --path vendor/bundle
pulsys@1ee4c7a8cfb3:/usr/local/src/dspace-jruby$ bundle exec yardoc
```

