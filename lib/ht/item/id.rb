require 'ht/item/constants'

module HT
  class Item
    # Utility methods for dealing with the pairtree
    # and splitting up the id into parts
    class ID

      attr_reader :id, :root, :pair_translated_barcode

      def initialize(id, pairtree_root: HT::SDRROOT)
        @id                      = id
        @pair_translated_barcode = self.barcode(HT.pairtree_gsub(id))
        @root                    = pairtree_root
      end

      def namespace(htid = id)
        htid.split('.', 2).first
      end

      def barcode(htid = id)
        htid.split('.', 2).last
      end

      def pairtree_path(htid=id)
        pair_subbed_barcode = if htid.nil?
                                pair_translated_barcode
                              else
                                barcode(HT.pairtree_gsub(htid))
                              end

        path = [namespace, 'pairtree_root'].concat pair_subbed_barcode.scan(/../)
        File.join(@root, *path, pair_subbed_barcode)
      end

      alias_method :dir, :pairtree_path

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
