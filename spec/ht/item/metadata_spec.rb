require 'spec_helper'
require 'ht/item/metadata'

describe HT::Item::Metadata do
  let(:htid) { 'loc.ark:/13960/t9w09k00s'}
  let(:md)   { HT::Item::Metadata.new(htid, metsfile_path: data_file('mets.xml'))}
  let(:pages) {156}

  it "gets the zipfile internal paths" do
    zipfile_internal_paths = md.ordered_zipfile_internal_text_paths
    expect(zipfile_internal_paths.first).must_match /00001/
    expect(zipfile_internal_paths.last).must_match /00156/
  end

end
