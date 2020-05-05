# DSpace for Vagrant

## Getting started

### Building the Vagrant Box from the HashiCorp:

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

### Building the Docker Container

```bash
docker build -t jrgriffiniii/dspace-docker-base .
docker run -it --name dspace --mount src="$(pwd)/ansible",target=/ansible,type=bind jrgriffiniii/dspace-docker-base
docker exec -it dspace ansible-playbook /ansible/playbooks/docker.yml
```

#### Building the Vagrant Box
```bash
vagrant up
```

## Accessing DSpace

One running, DSpace 6.3 should accessible at [http://localhost:8888/jspui/](http://localhost:8888/jspui/). The
administrator account created for the installation is `admin@localhost` using
the password `secret`.
