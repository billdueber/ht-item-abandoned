require 'spec_helper'
require 'ht/item/mets_file_entry'

describe HT::Item::MetsFileEntry do

  before do
    @args = {
      id:             "the_id",
      size:           "100",
      sequenceString: '%07d' % 1,
      mimetype:       'text/plain',
      created:        "2011-03-19T13:31:32Z",
      checksum:       "d41d8cd98f00b204e9800998ecf8427e"
    }
  end

  describe "basics" do
    it "loads and initializes" do
      expect(HT::Item::MetsFileEntry.new(@args)).must_be_kind_of HT::Item::MetsFileEntry
    end
  end


  describe "coercion" do
    before do
      @mfe = HT::Item::MetsFileEntry.new(@args)
    end

    it "computes sequence" do
      expect(@mfe.sequence).must_equal 1
    end

    it "generates date" do
      date = DateTime.new(2011, 3, 19, 13, 31, 32)
      expect(@mfe.created).must_equal date
    end

    it "finds the suffix" do
      expect(@mfe.suffix).must_equal "txt"
    end

    it "raises on unexpected mime type" do
      args = @args.dup
      args[:mimetype] = 'text/junk'
      expect(proc{HT::Item::MetsFileEntry.new(args)}).must_raise(ArgumentError)
    end

    it "produces a relative zipfile path" do
      expect(@mfe.zipfilepath).must_equal "/#{@args[:sequenceString]}.txt"
    end
  end
end

