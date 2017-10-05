require 'spec_helper'
require 'ht/item/id'

describe HT::Item::ID do
  let(:fake_root) {'/fake/root'}
  let(:htid) { 'uc1.c3292592' }
  let(:ark_htid) { 'loc.ark:/13960/t9w09k00s'}
  let(:ark_htid2) { 'ia.ark:/13960/t9w10cs7x'}
  let(:id)   { HT::Item::ID.new(htid) }
  let(:arkid) { HT::Item::ID.new(ark_htid)}

  # Actual paths from the filesystem
  let(:actual_mets_path) {
    {
      htid => '/sdr1/obj/uc1/pairtree_root/c3/29/25/92/c3292592/c3292592.mets.xml',
      ark_htid => '/sdr1/obj/loc/pairtree_root/ar/k+/=1/39/60/=t/9w/09/k0/0s/ark+=13960=t9w09k00s/ark+=13960=t9w09k00s.mets.xml',
      ark_htid2 => '/sdr1/obj/ia/pairtree_root/ar/k+/=1/39/60/=t/9w/10/cs/7x/ark+=13960=t9w10cs7x/ark+=13960=t9w10cs7x.mets.xml'
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
    expect(arkid.namespace).must_equal 'loc'
  end

  it "gets ark raw barcode" do
    expect(arkid.barcode).must_equal 'ark:/13960/t9w09k00s'
  end

  it "translates ark barcode" do
    expect(arkid.pair_translated_barcode).must_equal 'ark+=13960=t9w09k00s'
  end

  it "gets correct normal mets path" do
    expect(id.metsfile_path).must_equal actual_mets_path[id.id]
  end

  it "gets correct ark mets path" do
    expect(arkid.metsfile_path).must_equal actual_mets_path[arkid.id]
  end


end
