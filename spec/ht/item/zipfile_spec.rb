require 'spec_helper'
require 'ht/item/zipfile'

describe HT::Item::Zipfile do
  let(:zip) { sample_zip_file }
  let(:pages) {156}

  it "opens and gets text by internal filename" do
    texts = zip.text_contents_hashed_by_name
    random_page = Random.rand(156)
    seq = '%07d' % random_page
    matching_text = Regexp.new(seq)
    key = texts.keys.find{|k| matching_text.match(k)}
    expect(texts[key]).must_match matching_text
  end
end
