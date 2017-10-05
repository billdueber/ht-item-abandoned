require 'ht/item/id'
require 'ht/constants'
require 'ht/item/mets_file'
require 'nokogiri'
require 'forwardable'
require 'zip'


module HT
  class Item
    extend Forwardable


    attr_reader :id

    # Forward much of the interesting stuff to id/mets objects
    def_delegators :@id, :dir, :namespace, :barcode, :zipfile_path
    def_delegators :@mets, :ocr_files, :image_files, :coord_files, :plaintext_files

    def initialize(id, pairtree_root: HT::SDRROOT, mets: nil)
      @id           = HT::Item::ID.new(id, pairtree_root: pairtree_root)
      @mets         = mets || HT::Item::MetsFile.new(@id.metsfile_path)
      @page_entries = {
        ocr:    @mets.ocr_files.inject([]) {|acc, e| acc[e.seq] = e; acc},
        coord:  @mets.coord_files.inject([]) {|acc, e| acc[e.seq] = e; acc},
        images: @mets.image_files.inject([]) {|acc, e| acc[e.seq] = e; acc},
      }
      # TODO: Should all these arrays always be of the same length???
    end

    # Need to take something like 1..10, 11, 22, 33..100 and flatten it into
    # an array of sequence numbers
    def flat_list_of_indexes(*args)
      args.map{|x| Array(x)}.flatten
    end


    def zipfile(filename = zipfile_path)
      Zip::File.open(zipfile_path)
    end

    def get_ocr(*args)

    end


  end




end
