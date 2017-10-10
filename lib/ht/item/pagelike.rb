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

      def initialize
        @files = []
        if block_given?
          yield self
        end
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
