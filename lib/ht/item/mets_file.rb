require 'nokogiri'
require 'ht/item/mets_file_entry'

module HT
  class Item
    class MetsFile

      def initialize(filename)
        @filename = filename
      end

      def mets
        @mets ||= Nokogiri.XML(File.open(@filename))
      end

      def coord_files
        @coord_files ||= mets_file_entries('coordOCR')
      end

      def plaintext_files
        @plaintext_files ||= mets_file_entries('ocr')
      end

      alias_method :ocr_files, :plaintext_files

      def image_files
        @image_files ||= mets_file_entries('image')
      end


      def mets_file_entries(type, nokogiri_mets_document: self.mets)
        nokogiri_mets_document.css("METS|fileGrp[USE=#{type}] METS|file").
          inject([]) do |acc, nokogiri_file_node|
          acc << MetsFileEntry.new(
            id:             nokogiri_file_node.attr('ID'),
            size:           nokogiri_file_node.attr('SIZE'),
            sequence:       nokogiri_file_node.attr('SEQ'),
            sequenceString: nokogiri_file_node.attr('SEQ'),
            mimetype:       nokogiri_file_node.attr('MIMETYPE'),
            created:        nokogiri_file_node.attr('CREATED'),
            checksum:       nokogiri_file_node.attr('CHECKSUM')
          )
          acc
        end
      end

    end
  end
end
