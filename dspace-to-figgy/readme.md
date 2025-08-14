# Exporting a collection from DataSpace

The collections that we want to export are:

* Monographic reports and papers (Publicly Accessible) `88435/dsp016q182k16g`
* Monographs (access-restricted)
* another collection1
* another collection2


# Getting the ID of the collection

If you have the DSpace `handle` of a collection we can get the `id` via the API. For example for handle `88435/dsp016q182k16g` the following command will returns the details of the collection, including the `id`

```
curl https://dataspace.princeton.edu/rest/handle/88435/dsp016q182k16g

{
    "id":222,
    "name":"Monographic reports and papers (Publicly Accessible)",
    "handle":"88435/dsp016q182k16g",
    ...,
    "numberItems":1970
}
```


# Get collection items

The following command gets the list of items for the collection.

```
curl https://dataspace.princeton.edu/rest/collections/222/items > public-monograph-items.json
```

**QUESTION:** The above command only fetches the first 100, how do we fetch the rest?


# Generate the script to export the data

Run the following command to produce a bash shell script that will export the items from the collection:

```
ruby generate_export_script.rb > export_collection.sh
```

The script generated will have the call to the DSpace `dexport` tool that will export the given item:

```
sudo /dspace/bin/dspace export -i "88435/dsp012801pg38m" -t ITEM -d /home/pulsys/dspace_exports_hector/ -n 1
```


# Running the script

SSH to the DSpace server and run the script `export_collection.sh`. See [Exporting data from DataSpace](https://github.com/pulibrary/dspace-development/blob/main/docs/exporting_data.md) for more details about the export tool.


# Getting the files down

Since we use an intermediary machine (bastion machine) to connect to the DSpace server we need to reference that machine when we copy the files down from the DSpace server:

```
scp -r -J xxx@bastion xxx@gcp-machine:/home/pulsys/dspace_exports_hector/6/ .
```
