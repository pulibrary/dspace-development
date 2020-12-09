# DSpace at the Princeton University Library

## DSpace for Docker

### Provisioning with a local DSpace build
*Please note that this is the method which is easiest to use for locally developing and extending DSpace installations run in the container.*

#### Cloning from GitLab
```bash
cd docker/usr/local/src
git clone https://git.atmire.com/clients/princeton-5.git dspace-5.5-src-release
git checkout dataspace-client-DEV # For DataSpace
git checkout oar-client-DEV # For the Open Access Repository (OAR)
cd -
```

##### Building the Open Access Repository
The Symplectic RT4DS DSpace Module ([available as a GZip-compressed TAR](https://drive.google.com/file/d/1SvMY4lsOHLZcCv_9FX-iO7FssEBCsJ4U/view?usp=sharing)) must be included in order to build the OAR. After downloading this file, please place this in the `docker/usr/local/src` directory:

```bash
cd docker/usr/local/src
cp rt4ds.tar.gz .
tar -xvf rt4ds.tar.gz
```

##### Build the release
```bash
cd docker/usr/local/src/dspace-5.5-src-release/dspace
mvn clean install
mvn package -Denv=dev
cd -
```

#### Downloading a community release
```bash
cd docker/usr/local/src
wget "https://github.com/DSpace/DSpace/releases/download/dspace-5.5/dspace-5.5-src-release.zip"
unzip dspace-5.5-src-release.zip
cd -
```

##### Build the release
```bash
cd docker/usr/local/src/dspace-5.5-src-release/dspace
mvn dependency:go-offline
mvn package
cd -
```

### Run the Container
In one terminal, please run the following, as this will start the DSpace Container:

```
# This is only necessary if you haven't already built the base image
docker build -t pulibrary/dspace-docker-base .
source ./scripts/docker_run_local_storage.sh
```

Then please run the following in a separate terminal to provision the Container:

### Provision the Container
```
source ./scripts/docker_provision_local_storage.sh
```

### Accessing DSpace

Once running, DSpace should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using the password `secret`.
