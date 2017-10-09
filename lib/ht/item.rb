require 'ht/item/metadata'
require 'ht/item/zipfile'


module HT
  class Item
    def initialize(id, pairtree_root: HT::SDRROOT,
                   mets: nil,
                   zipfile: nil)
      @metadata = Metadata.new(id, pairtree_root: pairtree_root, mets: mets)
      @zipfile  = zipfile || Zipfile.new(@metadata.zipfile_path)
    end

    def text_blocks
      @metadata.
    end
  end
end
