# DataSpace

DataSpace is the DSpace implementation for Princeton University, currently
serving as the research data repository and platform for publishing graduate
dissertations, senior theses, research datasets from PU and PPPL stakeholders,
and a selection of monographs and periodicals maintained by the Princeton
University Library.

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

## Globus

[Globus](https://www.globus.org/) is a platform that allows users to upload and
download large datasets easily. When working with researchers, PRDS will link to
Globus through Dataspace's metadata instead of storing the data directly in Dataspace. 

[An example Dataspace dataset with data in Globus.](https://dataspace.princeton.edu/handle/88435/dsp01nz8062179)
[ITIMS Google Drive containing Globus documentation.](https://drive.google.com/drive/folders/1W3PM757IW6dMqD_kZizQVdNftvm1Ct6V?usp=sharing)

## The Senior Theses Collections and Thesis Central

Within the [Princeton University Undergraduate Senior Theses Community](https://dataspace.princeton.edu/handle/88435/dsp019c67wm88m), one is currently able to access the born-digital copies of senior theses submissions provided for Princeton University Library students. Please be aware that, for each academic department, one is provided with a DSpace Collection (such as [Chemistry](https://dataspace.princeton.edu/handle/88435/dsp018c97kq479).

On an annual basis, the thesis submissions are provided by Princeton University students using an implementation of [Vireo (an Electronic Thesis and Dissertation management system)](https://github.com/TexasDigitalLibrary/Vireo.git). This service is [Thesis Central](https://thesis-central.princeton.edu), and opens for student deposits between dates an March and May (within which thesis submissions are captured and stored for later import into DataSpace).

### Importing Thesis Central Submissions

#### Initializing the Build Environment

```bash
brew install tcsh
git clone https://github.com/pulibrary/dspace-python.git
cd dspace-python
asdf local python 2.7.17 # or pyenv local 2.7.17
pip install -U pyenv
pipenv shell
pipenv sync
```

#### Building DSpace Submission Information Packages

For this example, one will need to download three files in order to build the packages locally:

 * RestrictionsWithId.xlsx
 * ImportRestrictions.xlsx
 * AdditionalPrograms.xlsx

These should be downloaded directly or copied into the `export` directory.

Each of these are provided by colleagues within the Library using a privately-accessible Google Drive Folder. Please contact members of Digital Repository and Discovery Services for access to these.

```bash
/bin/tcsh

export department='Physics'

mkdir "export/$department"
cp export/RestrictionsWithId.xlsx "export/$department/RestrictionsWithId.xlsx"
cp export/ImportRestrictions.xlsx "export/$department/ImportRestrictions.xlsx"
cp export/AdditionalPrograms.xlsx "export/$department/AdditionalPrograms.xlsx"
```

##### Downloading Thesis Central Exports

One must then authenticate into https://thesis-central.princeton.edu, within
which one will have access to the administrative menu. Should one *not* be
provided with these privileges, then one must please request this from DRDS
colleagues.

Following this, one must download all submissions for the desired department using the user interface:


(Save the Thesis Central exports to "export/$department/ExcelExport.xlsx")
