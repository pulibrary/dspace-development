# Vagrant Development Environment for DSpace

## Getting Started

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
asdf local python 3.9.0 # or pyenv local 3.9.0
pip install pipenv
pipenv shell
pipenv sync
```
