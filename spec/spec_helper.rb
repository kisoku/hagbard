dir = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift("#{dir}/")
$LOAD_PATH.unshift("#{dir}/../lib")

require 'rubygems'
require 'spec'
require 'hagbard'

#Spec::Runner.configure do |config|
#    config.mock_with :mocha
#end
