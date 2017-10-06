require 'ht/item/mets_file'
require 'ht/constants'
require 'ht/item/id'

module HT
  class Item
    # A class to hold a "pagelike" item (e.g, a scan) that holds
    # the text, coords, and image

    class Pagelike
      include Comparable
      attr_accessor :order, :labels, :type, :orderlabel, :files

      # TODO: Ugh. Too much coupling? Why should the page object know its htid?
      def initialize
        @files = []
      end

      def each
        return enum_for(:each) unless block_given?
        @files.each {|x| yield x}
      end

      def <=>(other)
        order <=> other.order
      end

      def get_entry(type)
        @files.find {|x| x.type == type}
      end

      def filename(type)
        get_entry(type).filename
      end

    end
  end
end
