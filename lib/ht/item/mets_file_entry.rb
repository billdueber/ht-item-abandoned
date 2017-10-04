require 'date'

module HT
  class Item

    class MetsFileEntry

      SuffixMap = {
        'text/plain' => 'txt',
        'text/xml'   => 'xml',
        'image/jp2'  => 'jp2'
      }


      MimeTypes = Types::Strict::String.enum(*(SuffixMap.keys))

      attr_reader :id, :sequenceString, :mimetype, :checksum
      def initialize(id:, size:, sequenceString:, mimetype:,created:, checksum:)
        @id = id
        @size = size
        @sequenceString = sequenceString
        @mimetype = mimetype
        @createdString = created
        @checksum = checksum
      end

      def sequence
        @sequence ||= sequenceString.to_i
      end
      alias_method :seq, :sequence

      def created
        @created ||= DateTime.parse(@createdString)
      end


      def suffix
        SuffixMap[mimetype]
      end

      def zipfilepath
        "/#{sequenceString}.#{suffix}"
      end

    end
  end
end
