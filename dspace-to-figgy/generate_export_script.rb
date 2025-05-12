require "json"

export_folder = "/home/pulsys/dspace_exports_hector/"
dataspace_data = "public-monograph-items.json"

text = File.read(dataspace_data)
items = JSON.parse(text)
items.each_with_index do |item, index|
    handle = item["handle"]
    line = "sudo /dspace/bin/dspace export -i \"#{handle}\" -t ITEM -d #{export_folder} -n #{index+1}"
    puts line
end
