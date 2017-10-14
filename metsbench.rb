$:.unshift 'lib'
require 'ht/item'
require 'benchmark/ips'
# Parsing the mets file and creating the metadata object is turning out
# to be a real bottleneck. We'll try some stuff

FILENAME = "spec/data/mets.xml"
ID       = 'loc.ark:/13960/t9w09k00s'

# First, what I've got

def get_metadata_hti
  mets     = HT::Item::MetsFile.new(FILENAME)
  metadata = HT::Item::Metadata.new(ID, mets: mets)
  entries  = metadata.ordered_zipfile_internal_paths(:text)
end

# Now let's try with just lots of xpath calls instead
# of making lots of objects
def get_metadata_nokogiri_xpath
  mets = Nokogiri.XML(File.open(FILENAME))
  textfilenames = {}
  mets.xpath("METS:mets/METS:fileSec/METS:fileGrp[@USE=\"ocr\"]/METS:file").each do |tf|
    id = tf.attr('ID')
    filename = tf.xpath('METS:FLocat[1]/@xlink:href[1]').first.value
    textfilenames[id] = filename
  end

  zipfilenames = {}
  textfilenames.keys.each do |id|
    order =  mets.xpath("METS:mets/METS:structMap[1]/METS:div[@TYPE=\"volume\"]/METS:div/METS:fptr[@FILEID=\"#{id}\"]/../@ORDER").first.value
    zipfilenames[order] = File.join("zipfileprefix!", textfilenames[id])
  end
end

REPEAT = 20

Benchmark.ips do |x|
  x.report('ht/item') do
    get_metadata_hti
  end
  x.report('ht/xpath') do
    get_metadata_nokogiri_xpath
  end

  x.compare!

end
