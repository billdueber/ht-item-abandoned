module HT
  class Item
    class Metadata
      if defined? JRUBY_VERSION
        require 'ht/item/jruby_metadata'
        include HT::Item::JRubyMetadata
      else
        require 'ht/item/mri_metadata'
        include HT::Item::MRIMetadata
      end
    end
  end
end
