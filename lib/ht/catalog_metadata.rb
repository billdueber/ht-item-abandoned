require 'json'
require 'ht/constants'
require 'uri'

# Suppress warning on load
original_verbosity = $VERBOSE
$VERBOSE = nil
require 'httpclient'
$VERBOSE = original_verbosity

module HT
  class CatalogMetadata

    MAX_CACHE_SIZE = 500

    attr_accessor :catalog_solr_url, :docs, :client

    def initialize(seed_htids = [],
                   catalog_solr_url: HT::CatalogSolrURL)
      @catalog_solr_url = catalog_solr_url
      @client           = HTTPClient.new
      @docs             = {}
      self.clear_and_fill_with_ids(Array(seed_htids), catalog_solr_url: catalog_solr_url)
    end

    def [](htid)
      unless docs.has_key?(htid)
        if docs.size > 500
          clear_and_fill_with_ids(htid)
        else
          add_docs fetch_docs_hashed_by_htid(htid)
        end
      end
      docs[htid]
    end


    def add_docs(docs_hashed_by_htid)
      @docs = docs.merge(docs_hashed_by_htid)
    end

    def clear_and_fill_with_ids(htids, catalog_solr_url: self.catalog_solr_url)
      @docs        ||= {}
      htids = Array(htids)
      return if htids.empty?
      newdocs      = htids.reduce({}) {|h, htid| h[htid] = @docs[htid]; h}
      needed_htids = newdocs.keys.select {|k| newdocs[k].nil?}
      add_docs fetch_docs_hashed_by_htid(needed_htids)
    end

    def fetch_docs_hashed_by_htid(htids, catalog_solr_url: self.catalog_solr_url)
      result = JSON.parse(client.get_content(build_query(htids, catalog_solr_url: catalog_solr_url)))
      result['response']['docs'].reduce({}) do |h, doc|
        Array(doc['ht_id']).each {|htid| h[htid] = doc}
        h
      end
    end

    def build_query(htids, catalog_solr_url: self.catalog_solr_url)
      idquery = URI.escape "ht_id:(#{Array(htids).map{|x| "\"#{x}\""}.join(" OR ")})"
      "#{catalog_solr_url}/select?wt=json&q=#{idquery}"
    end
  end
end

