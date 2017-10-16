require 'ht/constants'
require 'ht/item/id'
require 'nokogiri'
require 'forwardable'


# The only thing the item is actually asking of the metadata right
# now is for a list of the interesting ids (e.g., text nodes) and
# the order of the zipfile names. So let's just do that.
#

module HT
  class Item
    class Metadata
      extend Forwardable
      attr_reader :idobj, :zipfileroot, :mets

      # Forward much of the interesting stuff to id/mets objects
      def_delegators :@idobj, :id, :dir, :namespace, :barcode, :zipfile_path

      def initialize(id, pairtree_root: HT::SDRDATAROOT, metsfile_path: nil)
        @idobj          = HT::Item::ID.new(id, pairtree_root: pairtree_root)
        metsfile_path ||= @idobj.metsfile_path
        @mets = Nokogiri.XML(File.open(mets_file_name))
        @zipfileroot    = @idobj.pair_translated_barcode
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
        mets.xpath("METS:mets/METS:fileSec/METS:fileGrp[@USE=\"ocr\"]/METS:file").each do |tf|
          id = tf.attr('ID')
          filename = tf.xpath('METS:FLocat[1]/@xlink:href[1]').first.value
          textfilenames[id] = filename
        end
        textfilenames
      end

    end
  end
end
