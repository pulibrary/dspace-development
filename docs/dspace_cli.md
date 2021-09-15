# DSpace Command-Line Interface (CLI)

(Please see [DSpace JRuby](dspace_jruby) and ensure the [RVM](https://rvm.io/), [JRuby](https://www.jruby.org/), and DSpace JRuby have been installed.)

## Installing

### Initializing the JRuby Environment
```bash
dspace@host:~$ source $HOME/.rvm/scripts/rvm
dspace@host:~$ rvm use jruby-9.2.13.0
```

### Installing Gem dependencies
```bash
dspace@host:~$ mkdir -p pulibrary-src
dspace@host:~$ cd pulibrary-src
dspace@host:~/pulibrary-src$ git clone https://github.com/pulibrary/dspace-cli.git
dspace@host:~/pulibrary-src$ cd dspace-cli
dspace@host:~/pulibrary-src/dspace-cli$ jgem install bundler
dspace@host:~/pulibrary-src/dspace-cli$ bundle install
```

### Starting the DSpace Ruby interpreter

You will need to first ssh and login as the `dspace` user (`sudo su - dspace`). Below, `$eperson` is whatever account you'd like to use to login when applying changes.

```bash
dspace@host:~$ source $HOME/.rvm/scripts/rvm
dspace@host:~$ cd ~/pulibrary-src/dspace-cli
dspace@host:~/pulibrary-src/dspace-cli$ bin/dspace-irb $eperson
  Using /dspace
  Loading jars
  Loading /dspace/config/dspace.cfg
  INFO: Loading provided config file: /dspace/config/dspace.cfg
  INFO: Using dspace provided log configuration (log.init.config)
  INFO: Loading: /dspace/config/log4j.properties
  Starting new DSpaceKernel
  DB jdbc:postgresql://localhost:5432/dspace_db, UserName=dspace_db_user,
  PostgreSQL JDBC Driver
  jruby-9.2.13.0 :001 >
```

### Configuration
```bash
dspace@host:~$ cd ~/pulibrary-src/dspace-cli
dspace@host:~$ vi config/dspace.yml
```

```yaml
jobs:
  bitstream_export_job:
    export_path: '/mnt/dspace_exports'
```

### Listing the CLI Tasks
```bash
dspace@host:~$ cd ~/pulibrary-src/dspace-cli
dspace@host:~/pulibrary-src/dspace-cli$ bundle exec thor list
```

## Usage

### Query API

#### Querying using an ID

```ruby
query = DSpace::CLI::Query.new
query.find_by_id(103031)
query.results.first.id
```

#### Querying using a Handle

```ruby
query = DSpace::CLI::Query.new
query.find_by_handle('88435/dsp01cr56n3903')
query.results.first.handle
```

### Updating Metadata

```ruby
query = DSpace::CLI::.Query.new
query.find_by_id(105884)
query.results.first.id
query.results.first.department
query.results.first.remove_metadata('pu', 'department', 'Mechanical and Aerospace Engineering')
query.results.first.department
```

```ruby
query = DSpace::CLI::.Query.new
query.find_by_id(105890)
query.results.first.id
query.results.first.add_metadata(schema: 'dc', element: 'contributor',
qualifier: 'author', value: 'J. Smith')
query.results.first.add_metadata(schema: 'pu', element: 'contributor',
qualifier: 'authorid', value: '1234567890')
```

### Bitstream Management

#### Exporting Bitstream Content
_This writes the bitstream to files on the local file system_

```ruby
query = DSpace::CLI::Query.new
query.find_by_handle('88435/dsp01kk91fp56s')
query.results.first.export_bitstreams
```

By default, the files are exported into `exports/bitstreams`. One may customize this within the configuration.

Following this, copying the exports using a utility such as `rsync` is quite straightforward:
```bash
~$ ssh -L 2222:proxy-host:22 dspace@host
~$ rsync -auvzi --progress -e 'ssh -p 2222' dspace@localhost:~/pulibrary-src/dspace-cli/exports/bitstreams/ .
```

Or, should this be configured for the location `/mnt/dspace_exports`:

```bash
~$ ssh -L 2222:proxy-host:22 dspace@host
~$ rsync -auvzi --progress -e 'ssh -p 2222' dspace@localhost:/mnt/dspace_exports/ .
```

The exports will be named after their bistream IDs. To pair them with their original filenames, you may want to use the DSpace API. For example, if you download `119610.bin`, you can get the filename (`models_hourglass.tar.gz`) from https://dataspace.princeton.edu/rest/bitstreams/119610. This can be especially useful if a record contains tens of files.

### Workflow Management

#### Adding and Removing Users from Task Pools

```ruby
query = DSpace::CLI::Query.new
query.find_by_id(105927)
query.results.first.id
query.results.first.workflow_item.id
query.results.first.workflow_item.state
query.results.first.workflow_item.add_task_pool_user("user@domain.edu")
query.results.first.workflow_item.remove_task_pool_user("user@domain.edu")
```

#### Removing Tasks from the MyDSpace Dashboard

```ruby
ep1 = Java::OrgDspaceEperson::EPerson.findByEmail(DSpace.context, 'user@domain.edu')
workflow_items = Java::OrgDspaceWorkflow::WorkflowItem.findByEPerson(DSpace.context, ep1)
ep2 = Java::OrgDspaceEperson::EPerson.findByEmail(DSpace.context, 'user@domain.edu')

workflow_items.to_a.map { |wfi| wfi.setOwner(ep2); wfi.update }
workflow_items.to_a.map { |wfi| wfi.getItem.setSubmitter(ep2); wfi.update }

updated_workflow_items = Java::OrgDspaceWorkflow::WorkflowItem.findByEPerson(DSpace.context, ep1)
updated_workflow_items.to_a.map { |wfi| wfi.getOwner }
```

*For multiple Items:*

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
department = 'Mechanical and Aerospace Engineering'
sub_query = query.find_by_department(department)
query.result_set.add_task_pool_user("user@domain.edu")
query.result_set.remove_task_pool_user("user@domain.edu")
```

#### Finding Workflow Items

```ruby
java_import(org.dspace.workflow.WorkflowItem)
java_import(org.dspace.workflow.WorkflowManager)
java_import(org.dspace.eperson.EPerson)
eperson = Java::OrgDspaceEperson::EPerson.findByEmail(DSpace.context, "user@domain.edu")

workflow_items = Java::OrgDspaceWorkflow::WorkflowManager.getPooledTasks(DSpace.context, eperson)
pool_items = workflow_items.to_a.map { |wfi| wfi.getItem }
pool_items.map { |item| item.getID }
```

#### Setting Item Submitters

```ruby
java_import(org.dspace.eperson.EPerson)
eperson = Java::OrgDspaceEperson::EPerson.findByEmail(DSpace.context, "user@domain.edu")

query = DSpace::CLI::SeniorThesisCommunity.query
query.find_by_id(105927)
query.results.first.submitter = eperson
query.results.first.update
```

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
department = 'Mechanical and Aerospace Engineering'
sub_query = query.find_by_department(department)
sub_query.result_set.submitter_email = 'user@domain.edu'
```

#### Refreshing Task Pools for Users in Groups

There is a known bug in DSpace 5.5 that causes users who are newly added to Groups not to be able to see or interact with tasks in the workflow pool associated with that Group in their dashboard when they log in.

In order to address this, manual intervention is needed.  Over the dspace-cli, the following commands must be executed to accomplish this:

```ruby
java_import(org.dspace.eperson.Group)
java_import(org.dspace.workflow.WorkflowItem)
java_import(org.dspace.workflow.WorkflowManager)
java_import(org.dspace.eperson.EPerson)

group = Group.findByName(DSpace.context, $GROUP_NAME)
members = Group.allMembers(DSpace.context, group)
eperson = Java::OrgDspaceEperson::EPerson.findByEmail(DSpace.context, $USER_ALREADY_IN_GROUP)

workflow_items = Java::OrgDspaceWorkflow::WorkflowManager.getPooledTasks(DSpace.context, eperson)
pool_items = workflow_items.to_a.map { |wfi| wfi.getItem }
pool_items.map { |item| item.getID }
items = pool_items.map { |item| DSpace::CLI::Item.new(item) }
items.each { |i| i.workflow_item.add_task_pool_user($USER_NEW_TO_GROUP) }
```
Where the variables in the above example are populated with values as follows:

* `$GROUP_NAME` is a quoted string of the name of the DataSpace group to which the user has been newly added (example: `"Lib_DigPubs_Reviewers"`).
* `$USER_ALREADY_IN_GROUP` is the email address associated with a user already in the `$GROUP_NAME` group before the tasks that need to be visible were created.
* `$USER_NEW_TO_GROUP` is the email address associated with the user who is newly associated with the `$GROUP_NAME` group, and needs to have the group's tasks that are currently in the group's workflow pool become visible to them.

Once the `items.each` loop at the bottom of the code block above completes, the change should be immediately visible in the DataSpace interface.

#### Advancing Workflow States

```ruby
query = DSpace::CLI::SeniorThesisCommunity.query
query.find_by_id(105927)
query.results.first.id
query.results.first.workflow_item.id
query.results.first.workflow_item.state
query.results.first.archived?
query.results.first.archive
DSpace.commit

new_query = DSpace::CLI::SeniorThesisCommunity.query.find_by_id(105927)
updated = new_query.results.first
updated.id
updated.archived?
updated.workflow_item
```

### Collection Management

```ruby
query = DSpace::CLI::SeniorThesisCommunity.query
query.find_by_id(100572)
query.results.first.handle
query.results.first.add_to_collection("88435/dsp01gx41mh91n")
query.results.first.collections
```

#### Moving Between Collections

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_by_department('Mechanical and Aerospace Engineering')
sub_query.result_set.members.map(&:id)
sub_query.result_set.add_to_collection('88435/dsp015m60qr96c')
sub_query.result_set.remove_from_collection('88435/dsp015m60qr96c')
```

#### Collection Methods

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_mechanical_and_aerospace_engineering_department_items
sub_query.results.length
```

#### Exporting Items

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_mechanical_and_aerospace_engineering_department_items
sub_query.results.each { |item| item.remove_duplicated_metadata }
sub_query.results.each { |item| item.update }
sub_query.results.each { |item| item.export }
```

#### Exporting Departments

```ruby
DSpace::CLI::SeniorThesisCommunity.export_departments("2020")
```

### Deleting Existing Items

```ruby
DSpace::CLI::SeniorThesisCommunity.collection_titles.map do |title|
  result_set = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020').find_by_department(title).results
  result_set.map { |item| item.delete }
end
```

### Import

```bash
export SOURCE_DIR=/tmp/exports/exports/
export MAPFILE=import-09-05-20.mapfile
/dspace/bin/dspace import --add --collection=88435/dsp015m60qr96c --source=$SOURCE_DIR --mapfile=$MAPFILE --eperson=user@domain.edu --workflow
```

#### Moving to New Collections

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')

department = 'Mechanical and Aerospace Engineering'
collection = '88435/dsp015m60qr96c'
sub_query = query.find_by_department(department)
sub_query.result_set.add_to_collection(collection)
sub_query.result_set.remove_from_collection('88435/dsp015m60qr96c')
```

#### Moving to Departmental Collections

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_by_certificate_program('Creative Writing Program')
sub_query.results.each { |item| item.find_collections_for_departments.each { |collection| collection.add_item(item) } }
sub_query.result_set.remove_from_collection('88435/dsp0179407x233')
sub_query.results.map { |item| item.collections.map { |collection| collection.title } }
```

### Batch Job Support

#### Updating the state of Items in batches

```ruby
department = 'Mechanical and Aerospace Engineering'
report_name = "#{DSpace::CLI::ResultSet.normalize_department_title(department)}.csv"
batch_input_file_path = File.join(DSpace::CLI::ItemStateReport.root_path, report_name)
job = DSpace::CLI::BatchUpdateJob.new(batch_input_file_path, '2020')
job.perform_update_state_jobs
```

#### Updating the Item titles

```ruby
Dir.glob('/tmp/batch_imports/*csv').each do |batch_input_file_path|
  job = DSpace::CLI::BatchUpdateJob.new(batch_input_file_path, '2020')
  job.perform_update_title_jobs
end
```

### Senior Theses Community

#### Querying using DSpace metadata fields
```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_by_department('Mechanical and Aerospace Engineering')
sub_query.results.map(&:id)
sub_query.results.map(&:handle)
sub_query.results.first.workflow_item
```

#### Querying using a title

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_by_title('Colors, Sounds, and Qualitative Particulars')
sub_query.results.map(&:id)
```

#### Querying using an author

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
sub_query = query.find_by_author('Smith, John')
sub_query.results.map(&:id)
```

#### Importing Vireo Spreadsheets

```ruby
require 'vireo/cli/export'
spreadsheet_path = '/tmp/mathematics.xlsx'
export = Vireo::CLI::Export.build_from_spreadsheet(file_path: spreadsheet_path, year: '2020')
export.build_batch_import
export.write_batch_import('mathematics.csv')
```

### Reporting

#### Generating a report for the state of Items

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
department = 'Mechanical and Aerospace Engineering'
sub_query = query.find_by_department(department)
report_name = "#{DSpace::CLI::ResultSet.normalize_department_title(department)}.csv"
report = sub_query.result_set.item_state_report(report_name)
report.write
```

*For entire graduating classes:*

```ruby
DSpace::CLI::SeniorThesisCommunity.write_item_state_reports("2020")
```

#### Generating a report for Items grouped by authors:

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
department = 'Mechanical and Aerospace Engineering'
sub_query = query.find_by_department(department)
report_name = "#{DSpace::CLI::ResultSet.normalize_department_title(department)}.csv"
report = sub_query.result_set.item_author_report(report_name)
report.write
```

*For entire graduating classes:*

```ruby
DSpace::CLI::SeniorThesisCommunity.write_item_author_reports("2020")
```

#### Generating a report for Items grouped by certificate programs:

```ruby
query = DSpace::CLI::SeniorThesisCommunity.find_by_class_year('2020')
department = 'Mechanical and Aerospace Engineering'
sub_query = query.find_by_department(department)
report_name = "#{DSpace::CLI::ResultSet.normalize_department_title(department)}.csv"
report = sub_query.result_set.item_certificate_program_report(report_name)
report.write
```

*For entire graduating classes:*

```ruby
DSpace::CLI::SeniorThesisCommunity.write_item_certificate_program_reports("2020")
```
