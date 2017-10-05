require 'nokogiri'
require 'ht/item/mets_file_entry'

module HT
  class Item
    class MetsFile

      def initialize(file_or_filename)
        if file_or_filename.respond_to? :read
          @mets = self.load_mets(file_or_filename)
        else
          @mets  = self.load_mets(File.open file_or_filename)
        end
      end

      def load_mets(io)
        Nokogiri.XML(io)
      end

      def mets
        @mets ||= load_mets(File.open(@filename))
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

      def name
        f         = mets.css("METS|fileGrp[USE=\"source METS\"] METS|file")
        inner     = f.css("METS|FLocat[OTHERLOCTYPE=SYSTEM]").first
        inner.get_attribute('xlink:href')
      end



      def mets_file_entries(type, mets_xml: self.mets)
        file_entries_of_type(mets_xml).inject([]) do |acc, file_node|
          name = MetsFileEntry.name_from_node(file_node)
          acc << MetsFileEntry.new(
            id:             file_node.attr('ID'),
            size:           file_node.attr('SIZE'),
            sequenceString: file_node.attr('SEQ'),
            mimetype:       file_node.attr('MIMETYPE'),
            created:        file_node.attr('CREATED'),
            checksum:       file_node.attr('CHECKSUM'),
            name:           name
          )
          acc
        end
      end

      private
      def file_entries_of_type(type, mets_xml: self.mets)
        mets_xml.css("METS|fileGrp[USE=#{type}] METS|file")
      end

    end
  end
end
