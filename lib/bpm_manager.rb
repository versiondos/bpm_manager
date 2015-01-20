require "bpm_manager/version"
require "rest-client"
require "json"

module BpmManager
  class << self
    attr_accessor :configuration
  end

  # Defines the Configuration for the gem
  class Configuration
    attr_accessor :bpm_vendor, :bpm_url, :bpm_username, :bpm_password, :bpm_use_ssl
    
    def initialize
      @bpm_vendor = ""
      @bpm_url = ""
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
  def self.uri(suffix = '')
    case configuration.bpm_vendor.downcase
      when 'redhat'
        URI.encode('http' + (configuration.bpm_use_ssl ? 's' : '') + '://' + configuration.bpm_username + ':' + configuration.bpm_password + '@' + configuration.bpm_url + '/business-central/rest' + (suffix.nil? ? '' : suffix))
      else
        ''
    end
  end

  # Gets all server deployments
  def self.deployments()
    return JSON.parse(RestClient.get(BpmManager.uri('/deployment'), :accept => :json))
  end

  # Gets all tasks, optionally you could specify an user id
  def self.tasks(user_id = "")
    return JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (user_id.empty? ? '' : '?taskOwner=' + user_id)), :accept => :json))
  end

  # Gets all tasks with options
  def self.tasks_with_opts(opts = {})
    return JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&'))), :accept => :json))
  end

  # Gets all Process Instances
  def self.process_instances
    return JSON.parse(RestClient.get(BpmManager.uri('/history/instances'), :accept => :json))
  end

  # Gets a Process Instance
  def self.process_instance(process_instance_id)
    return JSON.parse(RestClient.get(BpmManager.uri('/history/instance/' + process_instance_id.to_s), :accept => :json))
  end

  # Gets a Process Instance --simplified
  def self.process_instance_simplified(process_instance_id)
    return JSON.parse(RestClient.get(BpmManager.uri('/history/instance/' + process_instance_id.to_s), :accept => :json))['list'][0].first[1]
  end

  # Gets a Process Instance Variables
  def self.process_instance_variables(deployment_id, process_instance_id)
    return JSON.parse(RestClient.get(BpmManager.uri('/runtime/' + deployment_id.to_s + '/withvars/process/instance/' + process_instance_id.to_s), :accept => :json))['variables']
  end
  
  # Assigns a Task for an User
  def self.assign_task(task_id, user_id)
    return RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/delegate?targetEntityId=' + user_id.to_s), :headers => {:content_type => :json, :accept => :json}))
  end

  # Releases a Task
  def self.release_task(task_id)
    return RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/release'), :headers => {:content_type => :json, :accept => :json}))
  end

  # Completes a Task
  def self.complete_task(task_id)
    return RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/complete'), :headers => {:content_type => :json, :accept => :json}))
  end
end
