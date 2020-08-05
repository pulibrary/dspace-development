
# Troubleshooting

## Bundles and Bitstreams

```
handle = '88435/pr1x802'
item = DSpace.fromString(handle)
bundles = item.getBundles

bitstreams = []
bundles.each do |bundle|
  bitstreams += bundle.getBitstreams
end

io_stream = bitstreams.first.retrieve

# This is an instance of the edu.sdsc.grid.io.local.LocalFileInputStream Class
# Please see: https://github.com/irods/irods-legacy/blob/master/iRODS/jargon/src/api/edu/sdsc/grid/io/local/LocalFileInputStream.java
```

