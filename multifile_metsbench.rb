$:.unshift 'lib'
require 'ht/item'
require 'ht/item/metadata2'
require 'ht/item/metadata3'
require 'benchmark/ips'


htids = File.open('test_ids.txt').each_line.map(&:chomp).cycle


def get_metadata_hti(htid)
  id = HT::Item::ID.new(htid)
  mets     = HT::Item::MetsFile.new(id.metsfile_path)
  metadata = HT::Item::Metadata.new(htid, mets: mets)
  entries  = metadata.ordered_zipfile_internal_paths(:text)
end

def get_metadata2(htid)
  id = HT::Item::ID.new(htid)
  md2 = HT::Item::Metadata2.new(htid, mets_file_name: id.metsfile_path)
  entries  = md2.ordered_zipfile_internal_text_paths
end

def get_metadata3(htid)
  id = HT::Item::ID.new(htid)
  md3 = HT::Item::Metadata3.new(htid, mets_file_name: id.metsfile_path)
  entries  = md3.ordered_zipfile_internal_text_paths=
end

Benchmark.ips do |x|
  x.config(:time => 10, :warmup => 5)
  x.report('metadata1') do
    get_metadata_hti(htids.next)
  end

  x.report('metadata2') do
    get_metadata2(htids.next)
  end

  x.report('metadata3') do
    get_metadata3(htids.next)
  end

  x.compare!

end
