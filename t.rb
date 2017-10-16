$:.unshift 'lib'
require 'ht/item'
htid = "ien.35556021287453"

text_dehyphenate = /(\p{L}{2})\-\n(\p{L}{2})/

ids = File.open('test_ids.txt').each_line.map(&:chomp)
puts "STARTING..."
ids.take(200).each do |htid|
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


