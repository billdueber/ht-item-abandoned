require 'ht/constants'
require 'ht/item/id'
require 'forwardable'


# The only thing the item is actually asking of the metadata right
# now is for a list of the interesting ids (e.g., text nodes) and
# the order of the zipfile names. So let's just do that.
#
#
# Nokogiri under JRuby creates a zillion anonymous classes that
# slow things down to a crawl and result in out of memory errors,
# so on the jruby side we'll go mostly-java.
#

java_import javax.xml.namespace.NamespaceContext
java_import javax.xml.parsers.DocumentBuilder
java_import javax.xml.parsers.DocumentBuilderFactory
java_import javax.xml.xpath.XPath
java_import javax.xml.xpath.XPathConstants
java_import javax.xml.xpath.XPathExpression
java_import javax.xml.xpath.XPathFactory


module HT
  class Item
    module JRubyMetadata

      class NS
        include javax.xml.namespace.NamespaceContext
        MAP = {
          'METS'  => "http://www.loc.gov/METS/",
          'xlink' => "http://www.w3.org/1999/xlink"
        }

        def get_prefix(*args)
          nil
        end

        def get_prefixes(*args)
          nil
        end

        def getNamespaceURI(str)
          MAP[str]
        end
      end

      extend Forwardable
      attr_reader :idobj, :zipfileroot, :mets

      # Forward much of the interesting stuff to id object
      def_delegators :@idobj, :id, :dir, :namespace, :barcode, :zipfile_path

      BUILDERFACTORY = DocumentBuilderFactory.newInstance
      BUILDERFACTORY.setNamespaceAware(true)
      BUILDER = BUILDERFACTORY.newDocumentBuilder


      def self.new_compiled_xpath(str)
        xp = XPathFactory.newInstance.newXPath
        xp.setNamespaceContext(NS.new)
        xp.compile(str)
      end

      def initialize(id, pairtree_root: HT::SDRDATAROOT, metsfile_path: nil)
        @idobj         = HT::Item::ID.new(id, pairtree_root: pairtree_root)
        metsfile_path ||= @idobj.metsfile_path
        @mets          = BUILDER.parse(File.open(metsfile_path).to_inputstream)
        @zipfileroot   = @idobj.pair_translated_barcode
        @filexpaths    = {}
        @order_by_fileid = nil
      end


      ORDEREDIDSPATH = self.new_compiled_xpath "METS:mets/METS:structMap[1]/METS:div[@TYPE=\"volume\"]/METS:div/METS:fptr"
      def order_by_fileid(mets = self.mets)
        if @order_by_fileid.nil?
          @order_by_fileid = {}
          nodes = ORDEREDIDSPATH.evaluate(mets, XPathConstants::NODESET)
          nodes.length.times do |i|
            item              = nodes.item(i)
            fileid = item.get_attribute('FILEID')
            order  = item.get_parent_node.get_attribute('ORDER')
            @order_by_fileid[fileid] = order.to_i
          end
        end
        @order_by_fileid
      end
      
      
      def order_for_fileid(id)
        order_by_fileid[id]
      end

      def ordered_zipfile_internal_text_paths
        # First, get all the textfiles
        textfile_names = textfile_names_hashed_by_id

        # Get them all out of the struct so we have the order
        zipfilenames = {}
        textfile_names.keys.each do |id|
          order                    = order_for_fileid(id)
          zipfilenames[order.to_i] = File.join(@zipfileroot, textfile_names[id])
        end

        # And order them
        zipfilenames.keys.sort.map {|order| zipfilenames[order]}
      end


      TEXTFILEPATH = self.new_compiled_xpath("METS:mets/METS:fileSec/METS:fileGrp[@USE=\"ocr\"]/METS:file/METS:FLocat[1]")

      def textfile_names_hashed_by_id
        textfilenames = {}

        nodes = TEXTFILEPATH.evaluate(mets, XPathConstants::NODESET)
        nodes.length.times do |i|
          item              = nodes.item(i)
          id                = item.get_parent_node.get_attribute 'ID'
          filename          = item.get_attribute('xlink:href')
          textfilenames[id] = filename
        end
        textfilenames
      end


    end
  end
end
