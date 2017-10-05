module HT

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


