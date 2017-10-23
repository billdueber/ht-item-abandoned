module HT
  class Item
    class Zipfile
      if defined? JRUBY_VERSION
        require 'ht/item/jruby_zipfile'
        self.prepend HT::Item::JRubyZipfile
      else
        require 'ht/item/mri_zipfile'
        self.prepend HT::Item::MRIZipfile
      end

      def initialize(path)
        @path = path
      end

      IS_TEXT = ->(e) {e.name =~ /0+\d+\.txt\Z/}

      def text_contents_hashed_by_name
        contents_hashed_by_name(IS_TEXT)
      end
    end
  end
end

