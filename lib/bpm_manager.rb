require "bpm_manager/version"
require "rest-client"
require "json"

module BpmManager
  @config ||= {
    :bpm_vendor => "",
    :bpm_url => "",
    :bpm_username => "",
    :bpm_password => "",
    :bpm_use_ssl => false
  }
  
  @valid_config_keys = @config
  
  # Returns the configuration hash
  def self.config
    @config
  end
  
  # Configure through hash
  def self.configure(opts = {})
    opts.each{ |k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  # Returns the URI for the server plus a suffix
  def self.uri(suffix = '')
    case @config[:bpm_vendor].downcase
      when 'redhat'
        URI.encode('http' + (@config[:bpm_use_ssl] ? 's' : '') + '://' + @config[:bpm_username] + ':' + @config[:bpm_password] + '@' + @config[:bpm_url] + '/business-central/rest' + (suffix.nil? ? '' : suffix))
      else
        ''
    end
  end

  # Gets all server deployments
  def self.deployments()
    return JSON.parse(RestClient.get(BpmManager.uri('/deployment'), :accept => :json))
  end

  # Gets all server deployments
  def self.tasks(user_id = "")
    return JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (user_id.empty? ? '' : '?taskOwner='+user_id)), :accept => :json))
  end

  # Gets all server deployments
  def self.tasks_with_opts(opts = {})
    return JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (opts.empty? ? '' : '?' + opts.map{|k,v| puts k.to_s + '=' + v.to_s}.join('&'))), :accept => :json))
  end
end
