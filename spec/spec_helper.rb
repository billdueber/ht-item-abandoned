$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'


# Add for use within RubyMine
if ENV['RM_INFO'] =~ /\S/
  MiniTest::Reporters.use!
else
  MiniTest::Reporters.use! [Minitest::Reporters::SpecReporter.new(color: true)]
end


def data_file(filename)
  File.join(__dir__, 'data', filename)
end

def data_file_content(filename)
  File.read(data_file(filename))
end
