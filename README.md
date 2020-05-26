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
docker build -t pulibrary/dspace-development-base .
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
docker build -t pulibrary/dspace-development-base .
source ./scripts/docker_run.sh
```

Then please run the following in a second terminal to provision the Container:

```
source ./scripts/docker_provision.sh
```

## Getting started with Vagrant

### Provisioning the Vagrant Box locally

#### Initializing the Python environment (for Ansible)

```bash
pyenv local 3.7.7
pip install pipenv
pipenv shell
pipenv sync
```

```bash
vagrant up
vagrant provision
```

## Accessing DSpace

One running, DSpace 5.3 should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using the password `secret`.

## Development

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

#### Building with local DSpace modules

Please `cd` to the directory used for the source code:

```
cd docker/usr/local/src/dspace-5.3-src-release
```

Here, one should then `git clone` the modules which they wish to include in the DSpace build:

```
git clone https://github.com/pulibrary/dspace-extension-modules.git
```

At this point one should then only need to rebuild the source code base:
```
cd dspace-extension-modules
mvn package
cd ..
mvn package
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
docker rmi pulibrary/dspace-docker-base
```

#### Updating the Docker Image for new releases on Docker Hub

```bash
docker commit -a'PULSys User pulsys@princeton.edu' -m'Adding the latest changes to the 1.0.1 release' dspace pulibrary/dspace-development:1.0.1
docker tag pulibrary/dspace-development:1.0.1 pulibrary/dspace-development:latest
docker push pulibrary/dspace-development:1.0.1
docker push pulibrary/dspace-development:latest
```

#### Packaging the Vagrant Box

```
vagrant package --output dspace-development.box --include ubuntu-bionic-18.04-cloudimg-console.log --vagrantfile Vagrantfile
```

One may then upload a new release of the Box to [Vagrant Cloud](https://app.vagrantup.com/pulibrary).
