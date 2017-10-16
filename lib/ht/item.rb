require 'ht/item/version'
if defined? JRUBY_VERSION
  require 'ht/item/jruby_zipfile'
  require 'ht/item/jruby_metadata'  
else
  require 'ht/item/zipfile'
  require 'ht/item/metadata'
end



module HT
  class Item
    def initialize(id, pairtree_root: HT::SDRDATAROOT,
                   metsfile_path: nil,
                   zipfile: nil)
      @metadata = Metadata.new(id, pairtree_root: pairtree_root, metsfile_path: metsfile_path)
      @zipfile  = zipfile.nil? ? Zipfile.new(@metadata.zipfile_path) : zipfile
    end

    def generate_file_selector(wanted)
      ->(e) { wanted.include? e.name}
    end

    def text_blocks(files_we_want = @metadata.ordered_zipfile_internal_text_paths)
      is_interesting = generate_file_selector(files_we_want)
      hash_of_texts  = @zipfile.contents_hashed_by_name(is_interesting)
      files_we_want.map {|fname| hash_of_texts[fname].force_encoding(Encoding::UTF_8)}
    end
  end
end

