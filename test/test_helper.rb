require 'minitest/autorun'
require 'mocha/setup'
require 'pry'

require File.expand_path('../lib/adobe_connect.rb', File.dirname(__FILE__))

# Shared base tests for some objs
require File.expand_path('lib/adobe_connect/adobe_connect_base_tests.rb', File.dirname(__FILE__))
