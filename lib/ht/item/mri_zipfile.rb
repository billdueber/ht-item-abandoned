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

      def stream
        @stream ||= Zip::InputStream.new(@path)
      end


      def text_from_stream(stream)
        stream.read
      end

    end

  end
end
