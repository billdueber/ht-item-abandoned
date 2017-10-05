require 'date'

module HT
  class Item

    class MetsFileEntry
      attr_reader :id, :sequenceString, :mimetype, :checksum, :name

      def initialize(id:, size:, sequenceString:, mimetype:, created:, checksum:, name:)
        unless ValidMimetypes.include? mimetype
          raise ArgumentError, "Mimetype #{mimetype} not recognized ([#{ValidMimetypes.join(',')}]"
        end

        @id             = id
        @size           = size.to_i
        @sequenceString = sequenceString
        @mimetype       = mimetype
        @createdString  = created
        @checksum       = checksum
        @name           = name
      end

      def sequence
        @sequence ||= sequenceString.to_i
      end

      alias_method :seq, :sequence

      def created
        @created ||= DateTime.parse(@createdString)
      end

      def path_in_zipfile
        "/#{name}"
      end

    end
  end
end
