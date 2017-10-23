require 'ht/catalog_metadata'
require 'forwardable'
require 'datetime'

module HT
  class Item
    class Metadata
      if defined? JRUBY_VERSION
        require 'ht/item/jruby_metadata'
        self.prepend HT::Item::JRubyMetadata
      else
        require 'ht/item/mri_metadata'
        self.prepend HT::Item::MRIMetadata
      end


      extend Forwardable

      attr_accessor :catalog_metadata_lookup
      attr_reader :idobj, :zipfileroot, :mets


      # Forward much of the interesting stuff to id object
      def_delegators :@idobj, :id, :dir, :namespace, :barcode, :zipfile_path


      def initialize(id,
                     catalog_metadata_lookup: HT::CatalogMetadata.new,
                     pairtree_root: HT::SDRDATAROOT,
                     metsfile_path: nil)
        @idobj                   = HT::Item::ID.new(id, pairtree_root: pairtree_root)
        @zipfileroot             = @idobj.pair_translated_barcode
        @catalog_metadata_lookup = catalog_metadata_lookup
        @metadata_solr_document  = {}
      end

      UNCHANGED_CATALOG_FIELDS = %w[
      author_top
      author2
      callnosort
      callnumber
      countryOfPubStr
      edition
      hlb3Delimited
      hlb3Str
      hlb3Str
      language008_full
      lccn
      mainauthor
      sdrnum
      serialTitle
      serialTitle_a
      serialTitle_ab
      title_a
      title_ab
      title_top
      titleSort
      topicStr
    ]

      def metadata_solr_document
        cm                      = catalog_metadata
        @ht_json                 = JSON.parse(cm['ht_json'.freeze]).find {|x| x['htid'.freeze] == id}
        @metadata_solr_document = UNCHANGED_CATALOG_FIELDS.reduce({}) {|h, k| h[k] = cm[k]; h}

        @metadata_solr_document['id'] = id
        @metadata_solr_document['vol_id'] = id
        @metadata_solr_document['allfields'] = allfields(cm['fullrecord'])


        @metadata_solr_document.merge! ht_json_metadata(@ht_json)
        @metadata_solr_document.merge! dates(cm, @metadata_solr_document)
      end

      def catalog_metadata(id = self.id)
        @cm ||= catalog_metadata_lookup[id]
      end

      # Pull stuff out of the ht_json

      def ingest_date
        DateTime.parse @ht_json['injest']
      end

      def rights
        @ht_json['rights']
      end

      def collection_code
        @ht_json['collection_code']
      end

      def digitization_source
        @ht_json['dig_source']
      end

      def held_by
        @ht_json['heldby']
      end


      def ht_json_metadata(ht_json)
        {
          'volumn_enumcron'      => ht_json['enumcron'.freeze],
          'enumPublishDate'      => ht_json['enum_pubdate'.freeze],
          'enumPublishDateRange' => ht_json['enum_pubdate_range'.freeze],
          'htsource'             => ht_source_from_collection_code(ht_json['collection_code']),
        }
      end

      def dates(cm, msd)
        {
          'bothPublishDate'      => (msd['enumPublishDate'] or cm['publishDate']),
          'bothPublishDateRange' => (msd['enumPublishDateRange'] or cm['publishDateRange']),
          'date'                 => cm['publishDate']
        }
      end

      def allfields(marcxml = catalog_metadata_lookup[id]['fullrecord'])
        get_allfields_from_marcxml(marcxml)
      end


    end
  end
end
