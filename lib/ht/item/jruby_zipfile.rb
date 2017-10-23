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


    end

  end
end
