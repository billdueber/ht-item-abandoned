require 'ht/constants'

module HT
  class Item
    # Utility methods for dealing with the pairtree
    # and splitting up the id into parts
    class ID

      attr_reader :id, :root

      def initialize(id, pairtree_root: HT::SDRDATAROOT)
        @id                      = id
        @root                    = pairtree_root
      end

      def namespace(htid = id)
        htid.split('.', 2).first
      end

      def barcode(htid = id)
        htid.split('.', 2).last
      end

      # Some characters in the barcode portion need to be
      # translated to something else in order to be useful
      # in creating the pairtree directory struture
      def pair_translated_barcode(htid=id)
        barcode(HT.pairtree_gsub(id))
      end

      def dir(htid=id)
        prefix_components = [@root, namespace, 'pairtree_root']
        ptb = pair_translated_barcode(htid)
        #        relpath = ptb.scan(/../)
        relpath = ptb.chars.each_slice(2).map{|x| x.join('')}
        File.join(prefix_components, relpath, pair_translated_barcode(htid))
      end

      alias_method :pairtree_path, :dir

      def zipfile_path
        File.join(dir, "#{pair_translated_barcode}.zip")
      end

      def metsfile_path
        File.join(dir, "#{pair_translated_barcode}.mets.xml")
      end

    end
  end
end
