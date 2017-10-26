java_import java.util.zip.ZipInputStream
java_import java.util.zip.ZipFile
java_import java.io.InputStreamReader
java_import java.io.BufferedReader
java_import java.util.stream.Collectors

module HT
  class Item
    # A representation of the zipfile
    # on disk. Probably going to end up being
    # one of several "places where we keep crap"
    # implementations that respond to something
    # like #contents_hashed_by_name
    module JRubyZipfile

      # TODO: create a method that yields a name/stream to a block
      #

      ALWAYS_INTERESTING = ->(e) {true}

      def each_entry_and_stream(is_interesting_lambda = ALWAYS_INTERESTING)
        stream = ZipInputStream.new(java.io.FileInputStream.new(@path))
        while e = stream.get_next_entry
          yield [e, stream] if is_interesting_lambda.(e)
        end
      end

      # Return a hash mapping {filepath => contents}
      def contents_hashed_by_name(is_interesting_lambda)
        contents = {}

        each_entry_and_stream(is_interesting_lambda) do |e, stream|
          isr              = InputStreamReader.new(stream, 'UTF-8')
          br               = BufferedReader.new(isr)
          txt              = br.lines.collect(Collectors.joining("\n"))
          contents[e] = txt
        end
      end

      contents
    end
  end

end
