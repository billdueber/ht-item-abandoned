# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ht/item/version"

Gem::Specification.new do |spec|
  spec.name    = "ht-item"
  spec.version = HT::Item::VERSION
  spec.authors = ["Bill Dueber"]
  spec.email   = ["bill@dueber.com"]

  spec.summary  = %q{A representation of an HT item (useful internally only)}
  spec.homepage = "https://github.com/hathitrust/ht-item"
  spec.license  = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://gems.www.lib.umich.edu/"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f)}
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry"

  spec.add_development_dependency "simplecov"

  spec.add_dependency "rubyzip"
  spec.add_dependency "nokogiri"

end
