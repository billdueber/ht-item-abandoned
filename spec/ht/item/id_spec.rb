require 'spec_helper'
require 'ht/item/id'

describe HT::Item::ID do
  let(:htid) { 'uc1.c3292592' }
  let(:ark_htid) { 'ia.ark:/13960/t9w09k00s'}
  let(:id)   { HT::Item::ID.new(htid) }
  let(:arkid) { HT::Item::ID.new(ark_htid)}

  # Actual paths from the filesystem
  let(:actual_mets_path) {
    {
      'uc1.c3292592' => nil,
      'ia.ark:/13960/t9w09k00s' => nil
    }
  }

  it "gets normal namespace" do
    expect(id.namespace).must_equal 'uc1'
  end

  it "gets normal barcode" do
    expect(id.barcode).must_equal 'c3292592'
  end

  it "does a no-op pairtree translation" do
    expect(id.pair_translated_barcode).must_equal(id.barcode)
  end

  it "gets ark namespace" do
    expect(arkid.namespace).must_equal 'ia'
  end

  it "gets ark raw barcode" do
    expect(arkid.barcode).must_equal 'ark:/13960/t9w09k00s'
  end

  it "translates ark barcode" do
    expect(arkid.pair_translated_barcode).must_equal 'ark+=13960=t9w09k00s'
  end

  it "gets correct normal mets path" do
    skip "Fill in paths from filesystem"
    expect(id.metsfile_path).must_equal actual_mets_path[id.id]
  end

  it "gets correct ark mets path" do
    skip "Fill in paths from filesystem"
    expect(arkid.metsfile_path).must_equal actual_mets_path[arkid.id]
  end


end
