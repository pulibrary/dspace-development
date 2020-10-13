# DSpace for Docker and Vagrant

## Getting started with Docker

There are a number of options for building the Docker Container and provisioning
the environment. These are ordered with preference for the most expedient
methods:

### Provisioning with a local DSpace build
*Please note that this is the method which is easiest to use for locally developing and extending DSpace installations run in the container.*

#### Download the release
```bash
cd guest/opt
wget "https://github.com/DSpace/DSpace/releases/download/dspace-5.5/dspace-5.5-src-release.zip"
unzip dspace-5.5-src-release.zip
cd -
```

#### Build the release
```
cd guest/opt/dspace-5.5-src-release/dspace
mvn dependency:go-offline
mvn package
cd -
```

#### Run the Container
In one terminal, please run the following, as this will start the DSpace Container:

```
# This is only necessary if you haven't already built the base image
bin/dspace-docker build

bin/dspace-docker start
```

Then please run the following in a separate terminal to provision the Container:

#### Provision the Container
```
bin/dspace-docker provision
```

## Getting started with Vagrant

### Provisioning the Vagrant Box locally

```bash
vagrant up
vagrant provision
```

## Accessing DSpace

One running, DSpace 5.5 should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using the password `secret`.

## Development

### Initializing the Python environment (for Ansible)

```bash
pyenv local 3.8.5
pip install pipenv
pipenv shell --python 3.8.5
pipenv sync
```

### Developing locally for Docker

Please use the following in order to actively develop the mvn code base:
```
cd guest/opt/dspace-5.5-src-release
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

### Restoring from Database Exports

```
bin/dspace-docker postgres-shell
export TIMESTAMP=`date +%s`
pg_dump dspace > dspace_$TIMESTAMP.sql

pg_restore --host=localhost --port=5432 --username=dspace --dbname=dspace --format=custom --no-owner --no-privileges --verbose /opt/db/exports/dataspace.2020-09-04_02-00-01.sql.c

dropdb dspace
createdb dspace --owner=dspace
pg_dump dspace < dataspace.2020-09-04_02-00-01.sql
```

### DSpace JRuby and CLI Development

```
cd guest/opt
git clone https://github.com/pulibrary/dspace-jruby.git
git clone https://github.com/pulibrary/dspace-cli.git
```

```
bin/dspace-docker root-shell
\curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install jruby-9.2.13.0
exit
```

```
bin/dspace-docker shell
\curl -sSL https://get.rvm.io | bash -s stable
source /home/dspace/.rvm/scripts/rvm

rvm install jruby-9.2.13.0
cd /opt/dspace-cli
rvm use jruby-9.2.13.0
bundle install
source bin/jdspace bin/dspacerb admin@localhost
```

