require 'rubygems'
require 'bundler/setup'

require 'coveralls'
Coveralls.wear!

Bundler.require(:default)

require 'uni_sender'
require "data_macros"

RSpec.configure do |config|

  config.include(DataMacros)

end
