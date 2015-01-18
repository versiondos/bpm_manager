require "bpm_manager/version"
require "rest-client"
require "json"

module BpmManager
  class Server
    @valid_config_keys = @config
    
    # Initializes the defaults
    def initialize
      @config = {
        :bpm_vendor => "RedHat",
        :bpm_url => "bpm.beatcoding.com",
        :bpm_username => "Administrator",
        :bpm_password => "bc-power",
        :bpm_use_ssl => false,
        :time_stamp => Time.now.to_i }
        
      raise LoadError 'BpmManager Gem Configuration file has errors' if @config.values.any?{|v| v.nil?}
    end
  
    # Configure through hash
    def configure(opts = {})
      opts.each{ |k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
    end
    
    # Returns the configuration hash
    def config
      @config
    end
    
    # Returns the URI for the server plus a suffix
    def uri(suffix)
      case @config[:bpm_vendor]
        when 'RedHat'
          URI.encode('http' + (@config[:bpm_use_ssl] ? 's' : '') + '://' + @config[:bpm_username] + ':' + @config[:bpm_password] + '@' + @config[:bpm_url] + '/business-central/rest' + (suffix.nil? ? '' : suffix))
        else
          ''
      end
    end
    
    # Gets all server deployments
    def deployments()
      return JSON.parse(RestClient.get(uri('/deployment'), :accept => :json))
    end
  end
end
