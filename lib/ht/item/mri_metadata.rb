require 'ht/constants'
require 'ht/item/id'
require 'nokogiri'


# The only thing the item is actually asking of the metadata right
# now is for a list of the interesting ids (e.g., text nodes) and
# the order of the zipfile names. So let's just do that.
#

module HT
  class Item
    module MRIMetadata

      def initialize(id,
                     catalog_metadata_lookup: HT::CatalogMetadata.new,
                     pairtree_root: HT::SDRDATAROOT,
                     metsfile_path: nil)
        super
        metsfile_path ||= @idobj.metsfile_path
        @mets = Nokogiri.XML(File.open(metsfile_path))
      end

      def ordered_zipfile_internal_text_paths
        # First, get all the textfiles
        textfile_names = textfile_names_hashed_by_id
        # Get them all out of the struct so we have the order
        zipfilenames = {}
        textfile_names.keys.each do |id|
          order =  mets.xpath("METS:mets/METS:structMap[1]/METS:div[@TYPE=\"volume\"]/METS:div/METS:fptr[@FILEID=\"#{id}\"]/../@ORDER").first.value
          zipfilenames[order.to_i] = File.join(@zipfileroot, textfile_names[id])
        end

        # And order them
        zipfilenames.keys.sort.map{|order| zipfilenames[order]}
      end

      def textfile_names_hashed_by_id
        textfilenames = {}
        mets.xpath("METS:mets/METS:fileSec/METS:fileGrp[@USE=\"ocr\"]/METS:file/METS:FLocat[1]").each do |tf|
          id = tf.parent.attr('ID')
          filename = tf.attr('xlink:href')
          textfilenames[id] = filename
        end
        textfilenames
      end

      def get_allfields_from_marcxml(marcxml)
        Nokogiri.XML(marcxml).xpath('collection/record[1]/datafield').reject{|n| n.attr('tag').to_i <= 10}.map(&:text)
      end

    end
  end
end
