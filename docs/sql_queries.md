# PostgreSQL & other queries in Dataspace

To enter the Postgres command line, you need to be the `dspace` user (`sudo su - dspace`). The command is `psql`. [Here is a link to the database diagram](https://wiki.lyrasis.org/display/DSDOC5x/Storage+Layer?preview=/45548226/68355659/dspace5.png) for DSpace 5.

It sometimes may be quicker to use the [REST API](dataspace.princeton.edu/rest/) than creating a complicated query. And the JRuby DSpace wrapper ([documentation](https://dspace-development.readthedocs.io/en/latest/dspace_cli.html#bitstream-management)) may be simpler as well.

Useful commands:
* `\dt`: describe all tables
* `\d {TABLE}`: describe the given table
* `\copy ({query}) to '{filename}' as CSV HEADER`: saves the query to a CSV with a header
     * The query needs to be one line. It may be easier to save from `less` (just press `s` in `less` and it'll prompt you to create a log file). This won't be a CSV, but you can use '|' as a delimiter, and it'll get you close.

### Generate thesis report

Lynn Durgin wants an annual report on the contents and embargo status of all theses in Dataspace. (https://github.com/pulibrary/dspace-development/issues/313)

```sql
SELECT handle,size_bytes,(
    SELECT text_value as filename
    FROM metadatavalue
    WHERE metadatavalue.resource_id = bitstream.bitstream_id AND metadata_field_id = 64 
    -- 64 is dc.title in the metadata registry (this is visible in the dataspace admin view)
), (
    SELECT text_value as embargo_lift
    FROM metadatavalue
    WHERE metadatavalue.resource_id = item.item_id AND metadata_field_id = 81
   -- 81 is pu.embargo_lift in the metadata registry
), (
    SELECT text_value as embargo_terms
    FROM metadatavalue
    WHERE metadatavalue.resource_id = item.item_id AND metadata_field_id = 82
), (
    SELECT text_value as mudd_walkin
    FROM metadatavalue
    WHERE metadatavalue.resource_id = item.item_id AND metadata_field_id = 362
)
FROM item
-- Collect items with their handles and bitstreams
INNER JOIN item2bundle ON (item.item_id = item2bundle.item_id)
INNER JOIN bundle2bitstream ON (item2bundle.bundle_id = bundle2bitstream.bundle_id)
INNER JOIN bitstream on (bundle2bitstream.bitstream_id = bitstream.bitstream_id)
INNER JOIN handle on (handle.resource_id = item.item_id)
-- Collect the items where the pu.date.classyear is equal to the given report year
WHERE item.item_id IN (
    SELECT resource_id
    FROM metadatavalue
    WHERE metadata_field_id = 161 AND text_value = '2020'
) AND bitstream_format_id = 3; 
-- The bitstream_format_id of 3 selects only the PDFs, ignoring the license txt files
```

### Get large bitstreams

Get bitstreams over 1GB.

```sql
SELECT ib.item_id, bb.bitstream_id, size_bytes
FROM item2bundle ib
INNER JOIN bundle2bitstream bb ON ib.bundle_id = bb.bundle_id
INNER JOIN bitstream b ON bb.bitstream_id = b.bitstream_id
WHERE size_bytes > 1000000000 AND deleted = 'f'
```

### Connect large bitstreams with their download stats

[dspace-development#147](https://github.com/pulibrary/dspace-development/issues/147)

Download stats and view stats are collected in Solr. Atmire created command-line tools to help collect this information.

Given some `resource_id`:
```bash
# total downloads
solr-count statistics "type:0 AND owningItem:$id"

# downloads by ip
solr-facet statistics "type:0 AND owningItem:$id" ip

# total page views
solr-count statistics "type:2 AND id:$id"

# page views by ip
solr-facet statistics "type:2 AND id:$id" ip
```

When we wanted to access this data across many IDs this is how it was implemented:

```bash
# Get all items with large bitstreams (from above)
psql -c "COPY(
SELECT DISTINCT h.handle, ib.item_id
FROM handle h
INNER JOIN item2bundle ib ON h.resource_id = ib.item_id
INNER JOIN bundle2bitstream bb ON ib.bundle_id = bb.bundle_id
INNER JOIN bitstream b ON bb.bitstream_id = b.bitstream_id
WHERE size_bytes > 1000000000 AND deleted = 'f')
to STDOUT with CSV;" > item_ids.csv

# select the item_id and extract the solr stats for that item and
#   place it into a new csv
awk -F "\"*,\"*" '{print $2}' item_ids.csv | 
    while read id; 
         do solr-count statistics "type:0 AND owningItem:$id"; 
    done > item_stats.csv

# combine the two one-column CSVs into a new CSV
paste -d, item_ids.csv item_stats.csv > item_ids_and_stats.csv
```

### Get empty filenames

[dspace-development#284](https://github.com/pulibrary/dspace-development/issues/284), [dspace-development#289](https://github.com/pulibrary/dspace-development/issues/289)

Collect the collection, community, and handle data for all unnamed bitstreams. This is stored in DSpace as the `dc.title` metadata on Bitstreams, which is stored in the `metadata_field_id` as `64` though this could certainly change. This does not check if `dc.title` is `NULL` or an empty string.

```sql
SELECT (
    SELECT text_value as community_name
    FROM metadatavalue
    WHERE resource_type_id = 4 AND resource_id = community_id AND metadata_field_id = 64
),(
    SELECT text_value as collection_name
    FROM metadatavalue 
    WHERE resource_type_id = 3 AND resource_id = community2collection.collection_id AND metadata_field_id = 64
),handle,bitstream_id
FROM handle 
INNER JOIN item ON (item.item_id = handle.resource_id)
INNER JOIN item2bundle ON (item.item_id = item2bundle.item_id)
INNER JOIN bundle2bitstream ON (item2bundle.bundle_id = bundle2bitstream.bundle_id)
INNER JOIN collection2item on collection2item.item_id = item.item_id
INNER JOIN community2collection on community2collection.collection_id = collection2item.collection_id
WHERE bitstream_id IN (
    SELECT resource_id
    FROM metadatavalue WHERE resource_type_id = 0 
    GROUP BY resource_id 
    HAVING NOT (64 = ANY(ARRAY_AGG(metadata_field_id)))
);
```

### Get all metadata field registries

```sql
\copy (select * from metadatafieldregistry where metadata_schema_id=1) to 'dc-metadata.csv' with csv header;
\copy (select * from metadatafieldregistry where metadata_schema_id=2) to 'pu-metadata.csv' with csv header;
\copy (select * from metadatafieldregistry where metadata_schema_id=3) to 'dcterms-metadata.csv' with csv header;
\copy (select * from metadatafieldregistry where metadata_schema_id=4) to 'eperson-metadata.csv' with csv header;
```
