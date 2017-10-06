require 'nokogiri'
require 'ht/item/mets_file_entry'

module HT
  class Item
    # Stuff to parse out a mets file
    class MetsFile

      # Get data from nokogiri nodes
      module NokogiriQueries

        class << self
          def filename_from_file_entry_node(file_entry_node)
            file_entry_node.css("METS|FLocat[OTHERLOCTYPE=SYSTEM]").first.get_attribute('xlink:href')
          end

          def source_mets_name(mets_node)
            f     = mets_node.css("METS|fileGrp[USE=\"source METS\"] METS|file")
            inner = f.css("METS|FLocat[OTHERLOCTYPE=SYSTEM]").first
            inner.get_attribute('xlink:href')
          end

          # @return [Array<Nokogiri::XMLNode] XML nodes for each file entry
          def file_entries_of_type(type, mets_node)
            mets_node.css("METS|fileGrp[USE=#{type}] METS|file")
          end

        end

      end


      attr_reader :mets_node

      def initialize(file_or_filename)
        if file_or_filename.respond_to? :read
          @mets_node = self.load_mets(file_or_filename)
        else
          @mets_node = self.load_mets(File.open file_or_filename)
        end
        @source_mets_name = NokogiriQueries.source_mets_name(self.mets_node)
      end

      def load_mets(io)
        Nokogiri.XML(io)
      end

      def coord_files
        mets_file_entries('coordOCR')
      end

      def plaintext_files
        mets_file_entries('ocr')
      end

      alias_method :ocr_files, :plaintext_files

      def image_files
        mets_file_entries('image')
      end


      def mets_file_entries(type, mets_node: self.mets_node)
        NokogiriQueries.file_entries_of_type(type, mets_node).inject([]) do |entries, file_node|
          entries << MetsFileEntry.new(
            id:             file_node.attr('ID'),
            size:           file_node.attr('SIZE'),
            sequence: file_node.attr('SEQ'),
            mimetype:       file_node.attr('MIMETYPE'),
            created:        file_node.attr('CREATED'),
            checksum:       file_node.attr('CHECKSUM'),
            filename:       NokogiriQueries.filename_from_file_entry_node(file_node),
            type:           type
          )
          entries
        end
      end


    end
  end
end
