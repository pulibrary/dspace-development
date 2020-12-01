# DSpace Python

## Installing

### Ensure that Python is installed

```bash
dspace@host:~$ python --version
Python 2.7.17
```

### Installing the Amazon Web Services (AWS) Command-Line Interface (CLI)

```bash
dspace@host:~$ python -m pip install --user awscli
```

### Testing the AWS CLI

```bash
dspace@host:~$ export AWS_ACCESS_KEY_ID=<the key ID>
dspace@host:~$ export AWS_SECRET_ACCESS_KEY=<the key secret>
dspace@host:~$ export AWS_DEFAULT_REGION=us-east-1
dspace@host:~$ aws s3 ls s3://pppldataspace
```

### Installing the dspace-python Utilities

```bash
dspace@host:~$ mkdir -p pulibrary-src
dspace@host:~$ cd pulibrary-src
dspace@host:~/pulibrary-src$ git clone https://github.com/pulibrary/dspace-python.git
dspace@host:~/pulibrary-src$ cd dspace-python
```

## Usage
**This synchronizes the content within the AWS storage bucket and imports any new packages into the DSpace installation.

```bash
dspace@host:~/pulibrary-src$ aws s3 sync s3://pppldataspace $HOME/pulibrary-src/dspace-python/pppl/s3
dspace@host:~/pulibrary-src$ source $HOME/pulibrary-src/dspace-python/pppl/scripts/pppl_pull.sh
```
