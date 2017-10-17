require 'spec_helper'
require 'ht/item'

describe HT::Item do

  let(:mets) { sample_mets_file }
  let(:zip)  { sample_zip_file }
  let(:htid) { 'loc.ark:/13960/t9w09k00s'}
  let(:item) { HT::Item.new(htid, metsfile_path: data_file('mets.xml'), zipfile: zip)}

  it "loads" do
    expect(HT::Item::VERSION).wont_be_nil
  end

  it "gets text" do
    page_texts = item.text_blocks
    expect(page_texts[0]).must_match(/0+1 in/)
    expect(page_texts[99]).must_match(/0+100 in/)
  end


end
