module AdobeConnect
  module Config

    @settings = Hash.new

    class << self
      def merge(settings)
        @settings.merge(settings)
      end

      def declare(&block)
        instance_eval(&block)
      end

      def [](key)
        @settings[key]
      end

      def []=(key, value)
        @settings[key] = value
      end

      def settings; @settings; end

      private
      [:username, :password, :domain].each do |method|
        define_method(method) { |value| @settings[method] = value }
      end
    end
  end
end
