# DataSpace

This is a test.

DataSpace is the DSpace implementation for Princeton University, currently
serving as the research data repository and platform for publishing graduate
dissertations, senior theses, and a selection of monographs and periodicals
maintained by the Princeton University Library.

## Graduate Dissertation Collections

### Importing New Dissertations

```bash
$ git clone https://github.com/pulibrary/dspace-python.git
$ cd dissertations/etd-ingest
$ pyenv local 2.7.18
$ pip install pipenv
$ pipenv shell
$ pipenv install
$ export BATCH_ID=`date +%Y%m%d`
$ mkdir -p proquest_exports/$BATCH_ID
$ mkdir -p dspace_imports/$BATCH_ID
```

#### Transferring the ProQuest Packages

##### Tunneling over the SSH Connection

Please request the following from members of Digital Repository and Discovery Services (DRDS):

- `PROQUEST_PROXY_HOST`
- `PROQUEST_PROXY_PORT`
- `PROQUEST_HOST`
- `PROQUEST_USER`

```bash
$ export PROQUEST_PROXY_HOST="proquest-proxy.princeton.edu" # This is only an example value
$ export PROQUEST_PROXY_PORT=8080 # Example value
$ export PROQUEST_HOST="proquest.princeton.edu" # Example value
$ export PROQUEST_USER="user" # Example value
$ ssh -L $PROQUEST_PROXY_PORT:$PROQUEST_HOST:22 $PROQUEST_USER@$PROQUEST_PROXY_HOST
```

_Then, using another terminal, please invoke:_
```
$ sftp -P $PROQUEST_PROXY_PORT dspace@localhost
sftp> ls
```

##### Generate the List of Package File Names
```bash
$ echo "ls -lt" | sftp -P $PROQUEST_PROXY_PORT dspace@localhost > proquest_export_files.txt
```

##### Transfer the Packages

This example assumes that one is importing the `Oct 15` batch:

```bash
$ ./bin/transfer-proquest-exports 'Oct 15' `pwd`/proquest_exports/$BATCH_ID
```

##### Generate the DSpace Submission Information Packages
```bash
$ pipenv run python prepare_for_import.py proquest_exports/$BATCH_ID dspace_imports/$BATCH_ID
```
_In the STDOUT, please check for any REJECT error messages logged for a given
dissertation export._

##### Transfer the SIPs to the DataSpace server environment

Please request the following from members of Digital Repository and Discovery Services (DRDS):

- `DATASPACE_PROXY_HOST`
- `DATASPACE_PROXY_PORT`
- `DATASPACE_HOST`
- `DATASPACE_USER`

```bash
$ export DATASPACE_PROXY_HOST="0.0.0.0" # This is only an example value
$ export DATASPACE_PROXY_PORT=8080 # Example value
$ export DATASPACE_HOST="127.0.0.1" # Example value
$ ssh -L $DATASPACE_PROXY_PORT:$DATASPACE_HOST:22 pulsys@$DATASPACE_PROXY_HOST
```

_Then, using another terminal, please invoke:_
```bash
$ rsync \
  --archive \
  --update \
  --verbose \
  --compress \
  --progress \
  --rsh="ssh -p $DATASPACE_PROXY_PORT" \
  dspace_imports/$BATCH_ID dspace@localhost:~/dspace_imports/
```

##### Import the SIPs
```bash
$ ssh -J pulsys@$DATASPACE_PROXY_HOST dspace@$DATASPACE_HOST
dspace@DATASPACE_HOST:~$ /dspace/bin/dspace import -add --eperson $USER@princeton.edu --source $HOME/dspace_imports/$BATCH_ID/SUCCESS --mapfile $HOME/dspace_imports/$BATCH_ID/import.mapfile --workflow
```
