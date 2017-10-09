require 'rubyzip'
require 'ht/item/metadata'

module HT
  class Item
    # A representation of the zipfile
    # on disk
    class Zipfile
      def initialize(path)
        @path = path
        @name = File.split(path)[-1]
        @zip = Zip::File.open(@path)
      end

      def contents(zip_path)
        @zip.get_entry(zip_path).get_input_stream.read
      rescue Errno::ENOENT
        raise "No zipfile entry for path '#{zip_path}' found in #{@name}"
      end

    end
  end
end
