require "bpm_manager/version"
require "bpm_manager/red_hat"

module BpmManager
  class << self
    attr_accessor :configuration
  end

  # Defines the Configuration for the gem
  class Configuration
    attr_accessor :bpm_vendor, :bpm_url, :bpm_url_suffix, :bpm_username, :bpm_password, :bpm_use_ssl
    
    def initialize
      @bpm_vendor = ""
      @bpm_url = ""
      @bpm_url_suffix = ""
      @bpm_username = ""
      @bpm_password = ""
      @bpm_use_ssl = false
    end
  end

  # Generates a new configuration
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
  
  # Returns the URI for the server plus a suffix
  def self.uri(rest_service = '')
    case configuration.bpm_vendor.downcase
      when 'redhat'
        URI.encode('http' + (configuration.bpm_use_ssl ? 's' : '') + '://' + configuration.bpm_username + ':' + configuration.bpm_password + '@' + configuration.bpm_url + configuration.bpm_url_suffix + (rest_service.nil? ? '' : rest_service))
      else
        ''
    end
  end
end
