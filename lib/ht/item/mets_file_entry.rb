require 'date'

# TODO: Rewrite this so a single entry has all three files and can be ordered
module HT
  class Item

    class MetsFileEntry
      attr_reader :id, :sequence, :mimetype, :checksum, :filename, :type

      def initialize(id:, size:, sequence:, mimetype:, created:, checksum:, filename:, type:)
        @type          = type
        @id            = id
        @size          = size.to_i
        @sequence      = sequence
        @mimetype      = mimetype
        @created = DateTime.parse(created)
        @checksum      = checksum
        @filename      = filename
      end

      alias_method :seq, :sequence

      def created
        @created ||= DateTime.parse(@createdString)
      end

    end
  end
end
