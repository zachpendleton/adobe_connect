require 'active_support/core_ext/string/inflections'
require 'erb'
require 'net/https'
require 'nokogiri'

require 'adobe_connect/config'
require 'adobe_connect/response'
require 'adobe_connect/service'
require 'adobe_connect/param_formatter'
require 'adobe_connect/meeting_folder'
require 'adobe_connect/user'

# Public: Namespace for AdobeConnect classes/modules.
module AdobeConnect; end
