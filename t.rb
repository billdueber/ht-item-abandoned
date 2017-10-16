$:.unshift 'lib'
require 'ht/item'

text_dehyphenate = /(\p{L}{2})\-\n(\p{L}{2})/

# Approximate speed for this file on grog:
#  MRI: 200 items in 390 seconds    ≈ 0.5 items/second
#  JRuby: 1000 items in 468 seconds ≈ 2.1 items/second


ids = File.open('test_ids.txt').each_line.map(&:chomp)
puts "STARTING..."
ids.each do |htid|
  begin
    id = HT::Item::ID.new(htid)
    size = (File.size(id.metsfile_path) / 1024.0).floor
    item = HT::Item.new(htid)
  rescue => e
    puts "Trouble getting #{htid}: #{e}"
    raise e
  end
  print "mets: %10dk %25s" % [size, id.id]
  texts = item.text_blocks.map{|str| str.force_encoding(Encoding::UTF_8)}.join('').gsub(text_dehyphenate, "$1$2")
  puts "  text: %10dk" % (texts.size / 1024.0).floor


end


