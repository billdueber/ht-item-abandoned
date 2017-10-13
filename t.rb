$:.unshift 'lib'
require 'ht/item'
htid = "ien.35556021287453"

ids = File.open('test_ids.txt').each_line.map(&:chomp)
ids.each do |htid|
  begin
    id = HT::Item::ID.new(htid)
    size = (File.size(id.metsfile_path) / 1024.0).floor
    print "%10dk %25s" % [size, id.id]
    item = HT::Item.new(htid)
  rescue => e
    "Trouble getting #{htid}: #{e}"
    next
  end
  texts = item.text_blocks.map{|str| str.force_encoding(Encoding::UTF_8)}
  puts '  text: %10dk' % [(texts.join(' ').size / 1024.0).floor]
end

