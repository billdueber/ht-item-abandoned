require 'zip'

module HT
  class Item
    # A representation of the zipfile
    # on disk. Probably going to end up being
    # one of several "places where we keep crap"
    # implementations that respond to something
    # like #contents_hashed_by_name
    module MRIZipfile
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

      IS_TEXT = ->(e) { e.name =~ /0+\d+\.txt\Z/}
      def text_contents_hashed_by_name
        contents_hashed_by_name(IS_TEXT)
      end

    end

  end
end
