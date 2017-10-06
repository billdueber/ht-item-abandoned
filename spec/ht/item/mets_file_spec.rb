require 'spec_helper'
require 'ht/item/mets_file'


describe HT::Item::MetsFile do
  let(:metfile_real_name) {"ark+=13960=t9w09k00s.xml"}
  let(:pages) {156}

  let(:mets_file_path) {data_file('mets.xml').freeze}
  let(:doc) {Nokogiri.XML(data_file_content('mets.xml')).freeze}
  let(:mets_node) {HT::Item::MetsFile.new(mets_file_path).freeze}


  describe "load" do
    it "loads from a filename" do
      m = HT::Item::MetsFile.new(data_file('mets.xml')).mets_node
      expect(m.to_xml).must_equal doc.to_xml
    end

    it "loads from an io object" do
      io = File.open(data_file('mets.xml'))
      m  = HT::Item::MetsFile.new(io).mets_node
      expect(m.to_xml).must_equal doc.to_xml
    end

    describe "file_groups(fileGrp)" do
      it "ocr files" do
        expect(mets_node.ocr_files.size).must_equal pages
      end

      it "image files" do
        expect(mets_node.image_files.size).must_equal pages
      end

      it "coord files" do
        expect(mets_node.coord_files.size).must_equal pages
      end

    end
  end


end
