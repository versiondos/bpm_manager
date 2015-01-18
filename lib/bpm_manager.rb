require "bpm_manager/version"

module BpmManager
  def initialize
    # Configuration defaults
    @config = {}
    @valid_config_keys = nil
  end
  
  # Configure through hash
  def self.configure(opts = {})
    # opts.each { |k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  # Returns the configuration hash
  def self.config
    @config
  end
  
  def self.get_deployments()
    raise LoadError 'BPM Gem Configuration file has nil or blanks' if @config.values.any?{|v| v.nil? || v.empty?}
    
    url = 'http'+(@config[:bpm_use_ssl]?'s':'')+'://'+@config[:bpm_username]+':'+@config[:bpm_password]+'@'+@config[:bpm_server]+'/rest'
    sufix = '/deployment'
    
    return JSON.parse(RestClient.get(URI.encode(url+sufix), :accept => :json))
  end
end
