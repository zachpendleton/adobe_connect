module AdobeConnect
  module Config

    @settings = Hash.new

    def self.merge(settings)
      @settings.merge(settings)
    end

    def self.declare(settings)
      @settings.merge!(settings)
    end

    def self.[](key)
      @settings[key]
    end

    def self.[]=(key, value)
      @settings[key] = value
    end

    def self.settings; @settings; end
  end
end
