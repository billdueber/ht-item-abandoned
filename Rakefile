require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

Rake::TestTask.new(:spec_gc) do |t|
  oldtestopts = ENV['TESTOPTS'] || ''
  ENV['TESTOPTS'] = [ENV['TESTOPTS'], '-g'].join(' ')
  Rake::Task[:spec].invoke
  ENV['TESTOPTS'] = oldtestopts
end

task :default => :spec_gc
