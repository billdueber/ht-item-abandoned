require 'ht/item/version'
require 'ht/item/metadata'
require 'ht/item/zipfile'


module HT
  class Item
    def initialize(id, pairtree_root: HT::SDRDATAROOT,
                   mets: nil,
                   zipfile: nil)
      @metadata = Metadata.new(id, pairtree_root: pairtree_root, mets: mets)
      @zipfile  = zipfile.nil? ? Zipfile.new(@metadata.zipfile_path) : zipfile
    end

    def generate_file_selector(wanted)
      ->(e) { wanted.include? e.name}
    end

    def text_blocks(files_we_want = @metadata.ordered_zipfile_internal_paths(:text))
      is_interesting = generate_file_selector(files_we_want)
      hash_of_texts  = @zipfile.contents_hashed_by_name(is_interesting)
      files_we_want.map {|fname| hash_of_texts[fname]}
    end
  end
end

