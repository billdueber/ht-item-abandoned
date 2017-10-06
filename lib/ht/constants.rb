module HT

  # Types of files listed in the mets file
  # What are the fileGrp USE=X that we're interested in?
  PAGE_TYPES = {
    "ocr"      => :text,
    "coordOCR" => :coord,
    "image"    => :image
  }


  SDRROOT = ENV["SDRROOT"] || '/sdr1/obj' #raise("SDRROOT env variable not set")

  PAIRTREE_TRANSLATIONS = {
    ':' => '+',
    '/' => '=',
  }


  PAIRTREE_K_V = [PAIRTREE_TRANSLATIONS.keys.join(''),
                  PAIRTREE_TRANSLATIONS.values.join('')]



  def self.pairtree_gsub(str)
    str.tr(*PAIRTREE_K_V)
  end


end


