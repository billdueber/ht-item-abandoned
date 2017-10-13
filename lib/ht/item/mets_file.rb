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
            x = file_entry_node.xpath('METS:FLocat[@OTHERLOCTYPE=\'SYSTEM\']/@xlink:href')
          end

          def source_mets_name(mets_node)
            mets_node.xpath('METS:fileGrp[@USE="source METS"]/METS:file')
          end

          # @return [Array<Nokogiri::XMLNode] XML nodes for each file entry
         def file_entries_of_type(mets_node, type: )
           mets_node.xpath("METS:mets/METS:fileSec/METS:fileGrp[@USE=\"#{type}\"]/METS:file")
          end

         def volume_divs(mets_node, type: 'physical')
            mets_node.xpath("METS:mets/METS:structMap[1]/METS:div[@TYPE=\"volume\"]/METS:div")
          end

        end

      end


      attr_reader :mets_node

      def initialize(file_or_filename)
        @mets_node        = if file_or_filename.respond_to? :read
                              self.load_mets(file_or_filename)
                            else
                              self.load_mets(File.open(file_or_filename))
                            end
        @source_mets_name = NokogiriQueries.source_mets_name(self.mets_node)
        @pagelikes        = []
        @mfe = {}
      end

      def load_mets(io)
        Nokogiri.XML(io.read)
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

      def volume_divs(mets_node=self.mets_node)
        NokogiriQueries.volume_divs(mets_node)
      end


      def mets_file_entries(type, mets_node: self.mets_node)
        NokogiriQueries.file_entries_of_type(mets_node, type: type).inject([]) do |entries, file_node|
          entries << MetsFileEntry.new(
            id:       file_node.attr('ID'),
            size:     file_node.attr('SIZE'),
            sequence: file_node.attr('SEQ'),
            mimetype: file_node.attr('MIMETYPE'),
            created:  file_node.attr('CREATED'),
            checksum: file_node.attr('CHECKSUM'),
            type:     type,
            filename: NokogiriQueries.filename_from_file_entry_node(file_node)
          )
          entries
        end
      end
    end
  end
end
