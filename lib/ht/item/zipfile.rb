
module HT
  class Item
    class Zipfile
      if defined? JRUBY_VERSION
        require 'ht/item/jruby_zipfile'
        include HT::Item::JRubyZipfile
      else
        require 'ht/item/mri_zipfile'
        include HT::Item::MRIZipfile
      end
    end
  end
end

