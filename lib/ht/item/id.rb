require 'ht/item/constants'

module HT
  class Item
    # Utility methods for dealing with the pairtree
    # and splitting up the id into parts
    class ID

      attr_reader :id, :root

      def initialize(id, pairtree_root: HT::SDRROOT)
        @id                      = id
        @root                    = pairtree_root
      end

      def namespace(htid = id)
        htid.split('.', 2).first
      end

      def barcode(htid = id)
        htid.split('.', 2).last
      end

      def pair_translated_barcode(htid=id)
        barcode(HT.pairtree_gsub(id))
      end

      def dir(htid=id)
        prefix_components = [@root, namespace, 'pairtree_root']
        ptb = pair_translated_barcode(htid)
        relpath = ptb.scan(/../)
        File.join(prefix_components, relpath)
      end

      alias_method :pairtree_path, :dir

      def zipfile_path
        File.join(dir, "#{pair_translated_barcode}.zip")
      end

      def metsfile_path
        File.join(dir, "#{pair_translated_barcode}.mets.xml")
      end


      def pairtree_translate(htid = id)
        htid.tr(*PTTRANS)
      end

    end
  end
end
