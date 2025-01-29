# Exporting data from DataSpace

## Using the built-in tool
TODO: pending to add this section


## Using the REST API
DataSpace provides a REST API https://dataspace.princeton.edu/rest/ that we can use to query for information, including the items metadata and their files.

# Getting a list of collections

The following cURL command returns a list of collections:
```
curl https://dataspace.princeton.edu/rest/collections/
```

Collections have a `handle` and an `id`, for example:

```
<collection>
   <handle>88435/dsp01bg257f09p</handle>
   <id>221</id>
   <name>Monographic reports and papers (Access Limited to Princeton)</name>
</collection>

<collection>
   <handle>88435/dsp010z708w412</handle>
   <id>21</id>
   <name>Presentations, Reports, and Papers</name>
</collection>

<collection>
  <handle>88435/dsp015m60qr96c</handle>
  <id>361</id>
  <name>Aeronautical Engineering, 1945-1975</name>
</collection>
```

This is important because in some instances you'll need to pass the collection `id` to the API.


## Getting the list of items in a collection

The following cURL command returns a list of items inside a collection:

```
curl https://dataspace.princeton.edu/rest/collections/361/items
```

Like with collections, the information for each item includes a `handle` and an `id`

```
<item>
  <handle>88435/dsp01w6634361k</handle>
  <id>61</id>
</item>
```

You can use the `id` you get the `handle` of a record at any time:

```
curl https://dataspace.princeton.edu/rest/items/2315
```

and you can also use the `id` to get the rest of the metadata for a single item:

```
curl https://dataspace.princeton.edu/rest/items/61/metadata
```

You can use the `handle` to view the item directly in DataSpace by pointing your browser to
https://dataspace.princeton.edu/handle/88435/dsp01w6634361k


## Getting the list of files for a given item

You can fetch the list of files (bitstreams) associated with a given item with the following call:

```
curl https://dataspace.princeton.edu/rest/items/61/bitstreams
```

The typical response will include several bitstreams but for our purposes we are interested in the one where the `bundleName` is "ORIGINAL":

```
<bitstream>
  <id>122</id>
  <name>DataSpaceFundingModel_20100827.pdf</name>
  <type>bitstream</type>
  <bundleName>ORIGINAL</bundleName>
  <checkSum checkSumAlgorithm="MD5">b95bbe8f5dbaa6cfc9c34541ead323e7</checkSum>
  <retrieveLink>/bitstreams/122/retrieve</retrieveLink>
  <sequenceId>1</sequenceId>
  <sizeBytes>604999</sizeBytes>
</bitstream>
```

**WARNING:** Some items will return an empty array when you query for the list of files, for example the item `2315` returns an empty array when querying https://dataspace.princeton.edu/rest/items/2315/bitstreams even though there are files associated with this item as you can see directly in DataSpace https://dataspace.princeton.edu/handle/88435/dsp01hx11xf301. The problem seems to be that the files associated with this item are restricted as hinted by the  "Request a copy" button in DataSpace (as opposed to the normal 'View/Download" button)


## Fetching the content of a file

Once we have found the right bitstream to download we can use the `sequenceId` to build a URL to fetch the actual content of the file:

```
curl curl https://dataspace.princeton.edu/bitstream/88435/dsp01w6634361k/1 > DataSpaceFundingModel_20100827.pdf
```

Notice that this URL does not use the REST API (i.e. it goes straight to `/bitstream` without using `/rest`)
