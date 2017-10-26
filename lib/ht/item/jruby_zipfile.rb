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

      JOINER = Collectors.joining("\n")

      def stream
        @stream ||= ZipInputStream.new(java.io.FileInputStream.new(@path))
      end


      def text_from_stream(stream)
        isr = InputStreamReader.new(stream, 'UTF-8')
        br  = BufferedReader.new(isr)
        br.lines.collect(JOINER)
      end
    end
  end

end
