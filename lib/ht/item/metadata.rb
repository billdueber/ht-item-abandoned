require 'ht/constants'
require 'ht/item/pagelike'
require 'ht/item/id'
require 'nokogiri'
require 'forwardable'
require 'zip'


module HT
  class Item
    class Metadata
      extend Forwardable
      include Enumerable


      attr_reader :idobj, :pagelikes, :zipfileroot, :mets

      # Forward much of the interesting stuff to id/mets objects
      def_delegators :@idobj, :id, :dir, :namespace, :barcode, :zipfile_path

      def initialize(id, pairtree_root: HT::SDRDATAROOT, mets: nil)
        @idobj = HT::Item::ID.new(id, pairtree_root: pairtree_root)
        @mets = mets or HT::Item::MetsFile.new(@idobj.metsfile_path)
        @pagelikes      = self.read_pagelikes_from_mets(mets)
        @pagelikes_hash = @pagelikes.reduce({}) {|h, p| h[p.order] = p; h}
        @zipfileroot    = @idobj.pair_translated_barcode
      end

      def each
        return enum_for(:each) unless block_given?
        @pagelikes.each do |x|
          yield x
        end
      end

      # TODO: move zipfile internal path logic into the zipfile
      def ordered_zipfile_internal_paths(type = :text)
        self.map do |p|
          [@zipfileroot, p.filename(type)].join('/')
        end
      end

      def mets_file_entries(mets: self.mets, filegrps: HT::PAGE_TYPES.keys)
        if @mfes.nil?
          @mfes = {}
          filegrps.each do |filegrp|
            mets.mets_file_entries(filegrp).each {|mfe| @mfes[mfe.id] = mfe}
          end
        end
        @mfes
      end


      def read_pagelikes_from_mets(mets)
        mets.volume_divs.reduce([]) do |acc, vd|
          pl = pagelike_from_volume_div(vd)
          acc << pl
          acc
        end
      end


      # TODO: Use a real constructor for pagelike
      # TODO: write a real method to add files to a pagelike
=      def pagelike_from_volume_div(vd)
        pl            = Pagelike.new
        pl.order      = vd.get_attribute('ORDER').to_i
        pl.labels     = vd.get_attribute('LABEL').split(/\s*,\s*/)
        pl.type       = vd.get_attribute('TYPE')
        pl.orderlabel = vd.get_attribute('ORDERLABEL')
        vd.css('METS|fptr').each do |fptr|
          id = fptr.get_attribute('FILEID')
          pl.files << mets_file_entries[id]
        end
        pl
      end

      def pagelike(num)
        @pagelikes_hash[num]
      end

      alias_method :[], :pagelike

      def count
        @pagelikes.count
      end

      alias_method :size, :count

      # Need to take something like 1..10, 11, 22, 33..100 and flatten it into
      # an array of sequence numbers
      def flat_list_of_pagelike_numbers(*args)
        args.map {|x| Array(x)}.flatten
      end

    end
  end
end
