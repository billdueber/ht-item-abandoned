require 'ht/catalog_metadata'

module HT
  class Item
    class Metadata
      if defined? JRUBY_VERSION
        require 'ht/item/jruby_metadata'
        self.prepend HT::Item::JRubyMetadata
      else
        require 'ht/item/mri_metadata'
        self.prepend HT::Item::MRIMetadata
      end

      def initialize(id, pairtree_root: HT::SDRDATAROOT, metsfile_path: nil)
        @idobj         = HT::Item::ID.new(id, pairtree_root: pairtree_root)
        @zipfileroot   = @idobj.pair_translated_barcode
      end
    end
  end
end
