require 'spec_helper'
require 'ht/item/pagelike'

describe HT::Item::Pagelike do
  let(:p1) {
    HT::Item::Pagelike.new do |pl|
      pl.order = 1
      pl.orderlabel = ""
      pl.type = "page"
      pl.labels = %w(LEFT)
    end
  }

  let(:p2) { temp = p1.dup; temp.order = 2; temp }

  it "starts with an empty fileset" do
    expect(p1.files).must_be_empty
  end

  it "sorts correctly" do
    a = [p2, p1].sort
    expect(a[0].order).must_equal 1
  end

end
