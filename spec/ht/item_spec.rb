require 'spec_helper'
require 'ht/item'

describe HT::Item do
  describe "sequence_lists" do
    let(:id) {'loc.ark:/13960/t9w09k00s'}
    let(:mets_node) {HT::Item::MetsFile.new(data_file('mets.xml'))}
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
