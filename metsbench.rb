$:.unshift 'lib'
require 'ht/item'
require 'ht/item/metadata2'
require 'ht/item/metadata3'
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

def get_metadata2
  md2 = HT::Item::Metadata2.new(ID, mets_file_name: FILENAME)
  entries  = md2.ordered_zipfile_internal_text_paths
end

def get_metadata3
  md3 = HT::Item::Metadata3.new(ID, mets_file_name: FILENAME)
  entries  = md3.ordered_zipfile_internal_text_paths

end

Benchmark.ips do |x|
  x.config(:time => 10, :warmup => 5)
  x.report('metadata1') do
    get_metadata_hti
  end
  x.report('metadata2') do
    get_metadata2
  end
  x.report('metadata3') do
    get_metadata3
  end

  x.compare!

end
