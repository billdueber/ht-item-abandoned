require 'fileutils'
htid = 'loc.ark:/13960/t9w09k00s'
barcode = "ark+=13960=t9w09k00s"
pages = (1..156)

begin
  Dir.mkdir(barcode)
rescue
end

`gm convert xc:white empty.png`

gmopts = %w[-background white -resize 850x1100 -fill black -pointsize 32]
pages.each do |i|
  seq = '%07d' % i
  FileUtils.copy "fake_coords.xml", "#{barcode}/#{seq}.xml"

  File.open("#{barcode}/#{seq}.txt", "w") do |txt|
    txt.puts "This is the text for image #{seq} in volumne #{htid}"
  end

  imgfilename = "#{barcode}/#{seq}.JP2"
  Kernel.system [ 'gm', 'convert', 'empty.png', *gmopts, '-draw', %Q["text 50,100 'This is the text for image #{seq}\nin volume #{htid}'"], imgfilename].join(' ')

end

Kernel.system "zip", "-r", "#{barcode}.zip", "#{barcode}"
FileUtils.rmtree barcode
