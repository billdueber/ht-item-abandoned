require 'ht/constants'
require 'ht/item/pagelike'
require 'ht/item/id'
require 'nokogiri'
require 'forwardable'
require 'zip'


module HT
  class Item
    extend Forwardable
    include Enumerable


    attr_reader :id

    # Forward much of the interesting stuff to id/mets objects
    def_delegators :@idobj, :dir, :namespace, :barcode, :zipfile_path

    # TODO make Pagelikes.new use a mets_node so stuff can be tested
    def initialize(id, pairtree_root: HT::SDRROOT, mets_node: nil)
      @idobj        = HT::Item::ID.new(id, pairtree_root: pairtree_root)
      @pagelikes = HT::Item::Pagelikes.new(@id.metsfile_path)
      @id = @idobj.id
    end

    def each
      return enum_for(:each) unless block_given?
      @pagelikes.each {|x| yield x}
    end

    def pagelike(num)
      @pagelikes.find{|x| x.order == num }
    end

    def text_by_pagelike(*ordernums)
      pagelike_numbers = flat_list_of_pagelike_numbers(ordernums)
      zipfilenames = pagelike_numbers.reduce([]) do |acc, pln|
        acc << "#{id.pair_translated_barcode}/#{@pagelikes[pln].get_entry(:text)}"
      end
      # extract_from_zipfile()
    end

    # Need to take something like 1..10, 11, 22, 33..100 and flatten it into
    # an array of sequence numbers
    def flat_list_of_pagelike_numbers(*args)
      args.map{|x| Array(x)}.flatten
    end

  end




end
