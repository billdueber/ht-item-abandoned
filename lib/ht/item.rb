require 'ht/item/id'
require 'ht/item/constants'
require 'ht/item/mets_file'
require 'nokogiri'
require 'forwardable'


module HT
  class Item
    extend Forwardable


    attr_reader :id
    def_delegators :@id, :dir, :namespace, :barcode, :zipfile_path
    def_delegators :@mets, :ocr_files, :image_files, :coord_files

    def initialize(id, pairtree_root: HT::SDRROOT)
      @id = HT::Item::ID.new(id, pairtree_root: pairtree_root)
      @mets = HT::Item::MetsFile.new(@id.metsfile_path)
    end
  end


end
