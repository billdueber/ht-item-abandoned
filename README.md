# HT::Item -- internal HathiTrust item interface

## Example use (on a machine with access to the repo)

```ruby

require 'ht/item'

ENV['SDRDATAROOT']                     # => "/sdr1"

item = HT::Item.new "uc1.c105177123";  # => HT::Item id: uc1.c105177123
item.id                                # => "uc1.c105177123"
item.dir                               # => "/sdr1/obj/uc1/pairtree_root/c1/05/17/71/23/c105177123"
item.namespace                         # => "uc1"
item.barcode                           # => "c105177123"
item.zipfile_path                      # => "/sdr1/obj/uc1/pairtree_root/c1/05/17/71/23/c105177123/c105177123.zip"

# From the catalog
item.record_id            # => "008860014"
item.title                # => "Rasānah-ʼi Shīʻah : jāmiʻahʹshināsī-i āʼīnʹhā-yi sūgvārī ..."
item.ingest_date          # => #<DateTime: 2017-09-02T00:00:00+00:00 ((2457999j,0s,0n),+0s,2299161j)>
item.rights               # => "ic"
item.collection_code      # => "ucbk"
item.held_by              # => ["berkeley","columbia","harvard","loc","uchicago","umich","unc"]
item.digitization_source  # => "google"

# From the mets
item.ordered_zipfile_internal_text_paths  # => ["c105177123/UCAL_C105177123_00000001.txt",
                                          #     "c105177123/UCAL_C105177123_00000002.txt",...]

# From the zipfile: ordered array of the page texts
item.text_blocks  # => ["hia Media\n.OSeries\n۹۷۸-۹۶۴-۳۴۲۸۵-۱\nییطسلف نادیم یزکرم هاگشورف\nنفلت ...", ..., ]


```

## TODO

* Add more convenience methods to get stuff out of the catalog metadata
* Get stuff whose record-of-record is in the databse from the database
  * rights
  * print holdings
  * last update date
* Make it easier to make catalog/db calls in batches (API now is ugly)
* Make it easier to use on non-repo machines (to get access to all the catalog metadata easily)

