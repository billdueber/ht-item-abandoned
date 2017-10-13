$:.unshift 'lib'
require 'ht/item'
htid = "ien.35556021287453"

mets = HT::Item::MetsFile.new(File.open('35556021287453.mets.xml'))
puts "Got mets file"
metadata = HT::Item::Metadata.new(htid, mets: mets)
puts "Got metadata with #{metadata.count} pagelikes"
