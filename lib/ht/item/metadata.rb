if defined? JRUBY_VERSION
  require 'ht/item/jruby_metadata'
else
  require 'ht/item/mri_metadata'
end
