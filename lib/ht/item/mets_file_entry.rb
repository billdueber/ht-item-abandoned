require 'date'
require 'ht/constants'

# TODO: Rewrite this so a single entry has all three files and can be ordered
module HT
  class Item

    class MetsFileEntry
      attr_reader :id, :sequence, :mimetype, :checksum, :filename, :type

      # TODO: use combinations of attributes to determine where the thing lives
      # (e.g., LOCTYPE="OTHER" OTHERLOCTYPE="SYSTEM" means it's
      # in a zipfile)
      def initialize(id:, size:, sequence:, mimetype:, created:, checksum:, filename:, type:)
        @type          = HT::PAGE_TYPES[type]
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
