require 'ht/item/mets_file'
require 'ht/constants'

module HT
  class Item
    # A class to hold a "pagelike" item (e.g, a scan) that holds
    # the text, coords, and image


    class Pagelike
      include Comparable
      attr_accessor :order, :labels, :type, :orderlabel, :files

      def initialize
        @files = []
      end

      def <=>(other)
        order <=> other.order
      end

      def get_entry(type)
        @files.find {|x| x.type == type}
      end

    end


    class Pagelikes

      include Enumerable

      attr_reader :mets

      def initialize(mets_file)
        @mets      = MetsFile.new(mets_file)
        @pagelikes = self.read_pagelikes_from_mets(@mets)
      end

      def each
        return enum_for(:each) unless block_given?
        @pagelikes.each {|pl| yield pl}
      end


      def read_pagelikes_from_mets(mets)
        # First, get all the individual files listed
        mfes = {}
        HT::PAGE_TYPES.keys.each do |type|
          mets.mets_file_entries(type).each {|mfe| mfes[mfe.id] = mfe}
        end
        pls = mets.volume_divs.reduce([]) do |acc, vd|
          pl            = Pagelike.new
          pl.order      = vd.get_attribute('ORDER').to_i
          pl.labels     = vd.get_attribute('LABEL').split(/\s*,\s*/)
          pl.type       = vd.get_attribute('TYPE')
          pl.orderlabel = vd.get_attribute('ORDERLABEL')
          vd.css('METS|fptr').each do |fptr|
            id = fptr.get_attribute('FILEID')
            pl.files << mfes[id]
          end
          acc << pl
          acc
        end
        pls.sort
      end


    end
  end
end
