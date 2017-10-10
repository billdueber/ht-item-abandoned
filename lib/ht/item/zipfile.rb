require 'zip'
require 'ht/item/metadata'

module HT
  class Item
    # A representation of the zipfile
    # on disk
    class Zipfile
      def initialize(path)
        @path = path
      end

      # Return a hash mapping {filepath => contents}
      def contents_hashed_by_name(is_interesting_lambda)
        contents          = {}
        stream            = Zip::InputStream.new(@path)
        while e = stream.get_next_entry
          next unless is_interesting_lambda.(e)
          contents[e.name] = stream.read
        end
        contents
      end

      IS_TEXT = ->(e) { e.name =~ /\.txt\Z/}
      def text_contents_hashed_by_name
        contents_hashed_by_name(IS_TEXT)
      end

    end

  end
end
