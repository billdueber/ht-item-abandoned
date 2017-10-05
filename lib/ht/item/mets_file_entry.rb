require 'date'

module HT
  class Item

    class MetsFileEntry
      attr_reader :id, :sequenceString, :mimetype, :checksum, :name

      def initialize(id:, size:, sequenceString:, mimetype:, created:, checksum:, name:)
        @id             = id
        @size           = size.to_i
        @sequenceString = sequenceString
        @mimetype       = mimetype
        @createdString  = created
        @checksum       = checksum
        @name           = name
      end

      alias_method :filename, :name

      def sequence
        @sequence ||= sequenceString.to_i
      end

      alias_method :seq, :sequence

      def created
        @created ||= DateTime.parse(@createdString)
      end

      # convenience method to get the name out of a nokogiri node.
      # Not sure where this should live...
      def self.name_from_node(node)
        node.css("METS|FLocat[OTHERLOCTYPE=SYSTEM]").first.get_attribute('xlink:href')
      end

    end
  end
end
