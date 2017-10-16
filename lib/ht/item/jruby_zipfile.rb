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
        stream            = ZipInputStream.new(java.io.FileInputStream.new(@path))

        while e = stream.get_next_entry
          unless is_interesting_lambda.(e)
            next
          end

          isr = InputStreamReader.new(stream, 'UTF-8')
          br = BufferedReader.new(isr)
          txt = br.lines.collect(Collectors.joining("\n"))
          contents[e.name] = txt
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
