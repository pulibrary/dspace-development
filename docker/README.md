# Docker Development Environment for DSpace

## Getting Started

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

#### Accessing DSpace

One running, DSpace 5.3 should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using the password `secret`.

## Development

### Initializing the Python Environment (for Ansible)

```bash
asdf local python 3.9.0 # or pyenv local 3.9.0
pip install pipenv
pipenv shell
pipenv sync
```

### Initializing the Java Environment

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
docker rmi pulibrary/dspace-docker-base
```

#### Updating the Docker Image for new releases on Docker Hub

```bash
docker commit -a'John Smith jsmith@localhost.localdomain' -m'Adding the latest changes to the 1.0.1 release' dspace pulibrary/dspace-docker:1.0.1
docker tag pulibrary/dspace-docker:1.0.1 pulibrary/dspace-docker:latest
docker push pulibrary/dspace-docker:1.0.1
docker push pulibrary/dspace-docker:latest
```
