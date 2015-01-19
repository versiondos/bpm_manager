require "bpm_manager/version"
require "rest-client"
require "json"

module BpmManager
  @config = {
    :bpm_vendor => "",
    :bpm_url => "",
    :bpm_username => "",
    :bpm_password => "",
    :bpm_use_ssl => false }
      
  @valid_config_keys = @config

  # Configure through hash
  def self.configure(opts = {})
    opts.each{ |k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  # Returns the configuration hash
  def self.config
    @config
  end

  # Returns the URI for the server plus a suffix
  def self.uri(suffix = '')
    case @config[:bpm_vendor]
      when 'RedHat'
        URI.encode('http' + (@config[:bpm_use_ssl] ? 's' : '') + '://' + @config[:bpm_username] + ':' + @config[:bpm_password] + '@' + @config[:bpm_url] + '/business-central/rest' + (suffix.nil? ? '' : suffix))
      else
        ''
    end
  end

  # Gets all server deployments
  def self.deployments()
    raise LoadError 'BpmManager Gem Configuration file has errors' if @config.values.any?{|v| v.nil?}
    
    return JSON.parse(RestClient.get(BpmManager.uri('/deployment'), :accept => :json))
  end
end
