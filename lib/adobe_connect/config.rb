module AdobeConnect

	# Public: Manage configuration for AdobeConnect::Service objects, like
	# username/password/domain.
  module Config

    @settings = Hash.new

    class << self
			# Public: Merge the given settings hash into the current settings.
			#
			# settings - A hash of setting options.
			#
			# Returns nothing.
      def merge(settings)
        @settings.merge(settings)
      end

			# Public: Declare default Connect settings using a block.
			#
			# &block - A block with configuration options.
			#
			# Examples
			#
			# 	AdobeConnect::Config.declare do
			# 		username 'user@example.com'
			# 		password 'password'
			# 		domain   'http://connect.example.com'
			# 	end
			#
			# Returns nothing.
      def declare(&block)
        instance_eval(&block)
      end

			# Public: Fetch a single key value from the current settings.
			#
			# key - The key to fetch.
			#
			# Examples
			#
			# 	AdobeConnect::Config[:username] #=> 'user@example.com'
			#
			# Returns the value of the key (usually a string).
      def [](key)
        @settings[key]
      end

			# Public: Set a single key's value.
			#
			# key - The name of the key to set.
			# value - The value to set the key to.
			#
			# Examples
			#
			# 	AdobeConnect::Config[:username] = 'user@example.com'
			#
			# Returns nothing.
      def []=(key, value)
        @settings[key] = value
      end

			# Public: Getter for the internal settings hash.
			#
			# Returns a hash.
      def settings; @settings; end

      private
      [:username, :password, :domain].each do |method|
        define_method(method) { |value| @settings[method] = value }
      end
    end
  end
end
