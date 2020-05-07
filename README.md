# DSpace for Vagrant

## Getting started

### Building the Docker Container:

```bash
docker run -it --name dspace -p 8888:8080 jrgriffiniii/dspace-docker
```

### Building the Vagrant Box from the Vagrant Cloud:

```bash
vagrant init jrgriffiniii/dspace-vagrant
vagrant up
```

One will want to please review the [Vagrantfile
configuration](https://github.com/jrgriffiniii/dspace-vagrant/blob/master/Vagrantfile).

### Provisioning the Vagrant Box locally

#### Initializing the Python environment (for Ansible)

```bash
pyenv local 3.7.7
pip install pipenv
pipenv shell
pipenv sync
```

### Building the Docker Container locally

```bash
docker build -t jrgriffiniii/dspace-docker-base .
./scripts/docker_provision.sh
```

### Provisioning from a local environment

```bash
docker build -t jrgriffiniii/dspace-docker-base .
cd docker/usr/local/src
wget "https://github.com/DSpace/DSpace/releases/download/dspace-5.3/dspace-5.3-src-release.zip"
unzip dspace-5.3-src-release.zip
cd -
./scripts/docker_provision_local_storage.sh
```

#### Clearing the cached images

```bash
docker rmi $(docker images -q)
```

### Updating the Docker Container

```bash
docker commit -a'James Griffin jrgriffiniii@gmail.com' -m'Adding the latest changes to the 1.0.1 release' dspace jrgriffiniii/dspace-docker:1.0.1
docker tag jrgriffiniii/dspace-docker:1.0.1 jrgriffiniii/dspace-docker:latest
docker push jrgriffiniii/dspace-docker:1.0.1
docker push jrgriffiniii/dspace-docker:latest
```

#### Building the Vagrant Box

```bash
vagrant up
```

## Accessing DSpace

One running, DSpace 6.3 should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using
the password `secret`.
