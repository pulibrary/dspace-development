# DSpace for Vagrant

## Getting started

### Initializing the Python environment (for Ansible)
```bash
pyenv local 3.7.7
pipenv shell
pipenv sync
```

### Building the Vagrant Box
```bash
vagrant up
```

### Accessing DSpace

DSpace 6.5 should now be accessible at [http://localhost:8888]

## Under Development

The following tasks need to be implemented for the Ansible Playbook:

```
useradd -m dspace

createuser --username=postgres --no-superuser --pwprompt dspace
createdb --username=postgres --owner=dspace --encoding=UNICODE dspace
psql --username=postgres dspace -c "CREATE EXTENSION pgcrypto;"

cp [dspace-source]/dspace/config/local.cfg.EXAMPLE [dspace-source]/dspace/config/local.cfg

mkdir [dspace]
chown dspace [dspace]

cd [dspace-source]
mvn package

cd [dspace-source]/dspace/target/dspace-installer
ant fresh_install

Add these files:
[tomcat]/conf/Catalina/localhost

DEFINE A CONTEXT PATH FOR DSpace JSP User Interface: jspui.xml
DEFINE A CONTEXT PATH FOR DSpace Solr index: solr.xml
DEFINE A CONTEXT PATH FOR DSpace OAI User Interface: oai.xml
DEFINE A CONTEXT PATH FOR DSpace REST Interface: oai.xml
DEFINE A CONTEXT PATH FOR DSpace SWORD Interface: sword.xml
DEFINE A CONTEXT PATH FOR DSpace SWORDv2 Interface: swordv2.xml

  <?xml version='1.0'?>
  <!-- CHANGE THE VALUE OF "[app]" FOR EACH APPLICATION YOU WISH TO ADD -->
  <Context
      docBase="[dspace]/webapps/[app]"
      reloadable="true"
      cachingAllowed="false"/>

[dspace]/bin/dspace create-administrator

restart tomcat
```
