require 'spec_helper'
require 'ht/item/metadata'

describe HT::Item::Metadata do
  let(:mets) { sample_mets_file}
  let(:htid) { 'loc.ark:/13960/t9w09k00s'}
  let(:md)   { HT::Item::Metadata.new(htid, mets: mets)}
  let(:pages) {156}

  it "will get a pagelike" do
    expect(md.pagelike(100).order).must_equal 100
  end

  it "gets the right number of pagelikes" do
    expect(md.count).must_equal pages
  end

  it "returns an enumerator for pagelikes" do
    expect(md.pagelikes.each).must_be_instance_of Enumerator
  end

  it "loops through with each" do
    last_seq = nil
    md.each do |p|
      last_seq = p.order
    end
    expect(last_seq).must_equal pages
  end

  it "gets the zipfile internal paths" do
    zipfile_internal_paths = md.ordered_zipfile_internal_paths
    expect(zipfile_internal_paths.first).must_match /00001/
    expect(zipfile_internal_paths.last).must_match /00156/
  end

end
