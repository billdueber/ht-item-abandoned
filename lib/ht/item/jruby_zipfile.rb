import java.util.zip.ZipInputStream
import java.util.zip.ZipFile
import java.io.InputStreamReader
import java.io.BufferedReader
import java.util.stream.Collectors

module HT
  class Item
    # A representation of the zipfile
    # on disk. Probably going to end up being
    # one of several "places where we keep crap"
    # implementations that respond to something
    # like #contents_hashed_by_name
    class Zipfile
      def initialize(path)
        @path = path
      end

      # Return a hash mapping {filepath => contents}
      def contents_hashed_by_name(is_interesting_lambda)
        contents          = {}
        stream            = ZipInputStream.new(File.open(@path, 'rb').to_inputstream)
        # z = java.util.zip.ZipFile.new(@path)

        while e = stream.get_next_entry
          next unless is_interesting_lambda.(e)
          contents[e.name] = BufferedReader.new(InputStreamReader.new(stream)).lines().parallel().collect(Collectors.joining("\n"));
        end

        # z.entries.each do |e|
        #   next unless is_interesting_lambda.(e)
        #   instream = z.get_input_stream(e)
        #   contents[e.name] = BufferedReader.new(InputStreamReader.new(instream)).lines().parallel().collect(Collectors.joining("\n"));
        # end
        contents
      end

      IS_TEXT = ->(e) { e.name =~ /0+\d+\.txt\Z/}
      def text_contents_hashed_by_name
        contents_hashed_by_name(IS_TEXT)
      end

    end

  end
end
