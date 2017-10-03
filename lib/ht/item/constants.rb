module HT

  SDRROOT = ENV["SDRROOT"] || raise("SDRROOT env variable not set")

  PAIRTREE_TRANSLATIONS = {
    ':' => '+',
    '/' => '=',
  }


  MIMETYPE_SUFFIX = {
    "image/jp2"  => 'jp2',
    "text/xml"   => "xml",
    "text/plain" => 'txt'
  }



  PAIRTREE_K_V = [PAIRTREE_TRANSLATIONS.keys.join(''),
                  PAIRTREE_TRANSLATIONS.values.join('')]



  def self.pairtree_gsub(str)
    str.tr(*PAIRTREE_K_V)
  end


end


