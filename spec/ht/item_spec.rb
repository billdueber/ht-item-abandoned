require 'spec_helper'
require 'ht/item'

describe HT::Item do

  let(:mets) { sample_mets_file }
  let(:zip)  { sample_zip_file }
  let(:htid) { 'loc.ark:/13960/t9w09k00s'}
  let(:item) { HT::Item.new(htid, mets: mets, zipfile: zip)}

  it "loads" do
    expect(HT::Item::VERSION).wont_be_nil
  end

  it "gets text" do
    page_texts = item.text_blocks
    expect(page_texts[0]).must_match(/0+1 in/)
    expect(page_texts[99]).must_match(/0+100 in/)
  end




  describe "sequence_lists" do
    let(:id) {'loc.ark:/13960/t9w09k00s'}
    let(:mets_node) { sample_mets_file }
    let(:item) {HT::Item::Metadata.new(id, mets: mets_node)}

    it "one item" do
      expect(item.flat_list_of_pagelike_numbers(1)).must_equal [1]
    end

    it "multiple" do
      expect(item.flat_list_of_pagelike_numbers(1, 2, 7)).must_equal [1, 2, 7]
    end

    it "a range" do
      expect(item.flat_list_of_pagelike_numbers(1..5)).must_equal [1, 2, 3, 4, 5]
    end

    it "an array" do
      expect(item.flat_list_of_pagelike_numbers([1,2,3])).must_equal [1,2,3]
    end

    it "a mix of ranges and singles" do
      expect(item.flat_list_of_pagelike_numbers(21, 2..6, 11)).must_equal [21, 2, 3, 4, 5, 6, 11]
    end
  end



end
