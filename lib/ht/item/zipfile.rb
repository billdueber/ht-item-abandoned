module HT
  class Item
    class Zipfile

      ALWAYS_INTERESTING = ->(e) {true}
      IS_TEXT = ->(e) {e.name =~ /0+\d+\.txt\Z/}


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

      def each_entry_and_stream(is_interesting_lambda = ALWAYS_INTERESTING)
        while e = stream.get_next_entry
          yield [e, stream] if is_interesting_lambda.(e)
        end
      end

      # Return a hash mapping {filepath => contents}
      def text_hashed_by_filename(is_interesting_lambda)
        contents = {}
        each_entry_and_stream(is_interesting_lambda) do |e, stream|
          contents[e] = text_from_stream(stream)
        end
        contents
      end

      def all_txt_hashed_by_filename
        contents_hashed_by_name(IS_TEXT)
      end
    end
  end
end

