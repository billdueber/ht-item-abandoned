require 'ht/item/version'
require 'ht/item/zipfile'
require 'ht/item/metadata'
require 'ht/catalog_metadata'

require 'forwardable'



module HT
  class Item
    extend Forwardable

    def_delegators :@metadata, :id, :dir, :namespace, :barcode, :zipfile_path,
                   :ordered_zipfile_internal_text_paths,
                   :ingest_date, :rights, :collection_code, :digitization_source,
                   :held_by, :record_id, :title

    attr_accessor :catalog_metadata_lookup

    def initialize(id,
                   catalog_metadata_lookup: HT::CatalogMetadata.new,
                   pairtree_root: HT::SDRDATAROOT,
                   metsfile_path: nil,
                   zipfile: nil)
      @metadata = Metadata.new(id, pairtree_root: pairtree_root, metsfile_path: metsfile_path)
      @zipfile  = zipfile.nil? ? Zipfile.new(@metadata.zipfile_path) : zipfile
      @catalog_metadata_lookup = catalog_metadata_lookup
    end

    def inspect
      "HT::Item id: #{id}"
    end

    def generate_file_selector(wanted)
      is_wanted = wanted.reduce({}) {|h, k| h[k] = true; h}
      ->(e) {is_wanted.has_key? e.name}
    end

    def text_blocks(files_we_want = @metadata.ordered_zipfile_internal_text_paths)
      is_interesting = generate_file_selector(files_we_want)
      hash_of_texts  = @zipfile.contents_hashed_by_name(is_interesting)
      files_we_want.map {|fname| hash_of_texts[fname].force_encoding(Encoding::UTF_8)}
    end


  end
end

