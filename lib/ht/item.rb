require 'ht/constants'
require 'ht/item/pagelike'
require 'ht/item/id'
require 'nokogiri'
require 'forwardable'
require 'zip'


module HT
  class Item
    extend Forwardable


    attr_reader :id

    # Forward much of the interesting stuff to id/mets objects
    def_delegators :@id, :dir, :namespace, :barcode, :zipfile_path
    def_delegators :@mets_node, :ocr_files, :image_files, :coord_files, :plaintext_files

    def initialize(id, pairtree_root: HT::SDRROOT, mets_node: nil)
      @id        = HT::Item::ID.new(id, pairtree_root: pairtree_root)
      @pagelikes = HT::Item::Pagelikes.new(@id.metsfile_path
    end


    # Need to take something like 1..10, 11, 22, 33..100 and flatten it into
    # an array of sequence numbers
    def flat_list_of_indexes(*args)
      args.map{|x| Array(x)}.flatten
    end

  end




end
