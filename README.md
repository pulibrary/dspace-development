# DSpace for Docker and Vagrant

## Getting started with Docker

There are a number of options for building the Docker Container and provisioning
the environment. These are ordered with preference for the most expedient
methods:

### Provisioning using pre-built DSpace installations

**Please download the [pre-built DSpace source code](https://drive.google.com/file/d/1OiSHK0wBhxYP26h94qe68_JmXiOZFXE-/view?usp=sharing) and the [pre-configured build](https://drive.google.com/file/d/1o2lQ54b_YrzqMaVenGMoSK99if06oX0l/view?usp=sharing) first.**

```bash
cd docker/usr/local/src
unzip dspace-5.3-release.zip
cd -
# If you wish to use Maven to build the packages
cd docker/usr/local/src/dspace-5.3-release
mvn dependency:go-offline
mvn package
cd -

cd docker/
unzip dspace.zip
cd -
```

In one terminal, please run the following, as this will start the DSpace Container:

```
# This is only necessary if you haven't already built the base image
docker build -t jrgriffiniii/dspace-docker-base .
source ./scripts/docker_run_local_storage.sh
```

Then please run the following in a second terminal to provision the Container:

```
docker cp "$(pwd)/docker/dspace" dspace:/dspace
docker cp "$(pwd)/docker/usr/local/src/dspace-5.3-release" dspace:/usr/local/src/dspace-5.3-release
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

### Developing locally

Please use the following in order to actively develop the mvn code base:
```
cd docker/usr/local/src/dspace-5.3-release
```

When this is ready for deployment, please use the following to repackage the build and deploy the webapps in the container:
```
mvn package
docker exec -it --workdir /usr/local/src/dspace-5.3-release/dspace/target/dspace-installer dspace ant update_webapps
docker exec -it dspace service tomcat8 stop
docker exec -it dspace service tomcat8 start
```

### Docker Image Management

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

