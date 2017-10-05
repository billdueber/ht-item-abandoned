require 'spec_helper'
require 'ht/item/mets_file'


describe HT::Item::MetsFile do
  before(:all) do
    @mets_file_path = data_file('mets.xml').freeze
    @doc = Nokogiri.XML(data_file_content('mets.xml')).freeze
    @mets = HT::Item::MetsFile.new(@mets_file_path).freeze

  end

  describe "load" do
    it "loads from a filename" do
      m = HT::Item::MetsFile.new(data_file('mets.xml')).mets
      expect(m.to_xml).must_equal @doc.to_xml
    end

    it "loads from an io object" do
      io = File.open(data_file('mets.xml'))
      m = HT::Item::MetsFile.new(io).mets
      expect(m.to_xml).must_equal @doc.to_xml
    end
  end

  describe "top_level" do
    it "finds the name" do
      expect(@mets.name).must_equal "IA_ark+=13960=t9w09k00s.xml"
    end
  end

  describe "file_groups(fileGrp)" do


  end



end
