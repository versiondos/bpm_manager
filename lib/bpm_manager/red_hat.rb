require "rest-client"
require "json"
require "ostruct"

module BpmManager
  module RedHat
    # Gets all server deployments
    def self.deployments()
      return JSON.parse(RestClient.get(BpmManager.uri('/deployment'), :accept => :json))
    end
    
    # Gets all tasks, optionally you could specify an user id
    def self.tasks(user_id = "")
      self.structure_task_data(JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (user_id.empty? ? '' : '?taskOwner=' + user_id)), :accept => :json)))
    end
    
    # Gets all tasks with options
    def self.tasks_with_opts(opts = {})
      self.structure_task_data(JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&'))), :accept => :json)))
    end
    
    # Gets all Process Instances
    def self.process_instances
      JSON.parse(RestClient.get(BpmManager.uri('/history/instances'), :accept => :json))
    end
    
    # Gets a Process Instance
    def self.process_instance(process_instance_id)
      JSON.parse(RestClient.get(BpmManager.uri('/history/instance/' + process_instance_id.to_s), :accept => :json))
    end
    
    # Gets a Process Instance Variables
    def self.process_instance_variables(deployment_id, process_instance_id)
      JSON.parse(RestClient.get(BpmManager.uri('/runtime/' + deployment_id.to_s + '/withvars/process/instance/' + process_instance_id.to_s), :accept => :json))['variables']
    end
    
    # Assigns a Task for an User
    def self.assign_task(task_id, user_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/delegate?targetEntityId=' + user_id.to_s)), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Starts a Task
    def self.start_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/start')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Stops a Task
    def self.stop_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/stop')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Suspends a Task
    def self.suspend_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/suspend')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Resumes a Task
    def self.resume_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/resumes')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Releases a Task
    def self.release_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/release')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Skips a Task
    def self.skip_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/skip')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Completes a Task
    def self.complete_task(task_id, opts = {})
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/complete')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Fails a Task
    def self.fail_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/fail')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Exits a Task
    def self.exit_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/exit')), :headers => {:content_type => :json, :accept => :json})
    end
    
    private
      def self.structure_task_data(input)
        tasks = []
        
        unless input['taskSummaryList'].nil?
          input['taskSummaryList'].each do |task|
            my_task = OpenStruct.new
            my_task.process = OpenStruct.new
            my_task.id = task['task-summary']['id']
            my_task.process_instance_id = task['task-summary']['process-instance-id']
            my_task.parent_id = task['task-summary']['parent_id']
            my_task.created_on = Time.at(task['task-summary']['created-on']/1000)
            my_task.active_on = Time.at(task['task-summary']['activation-time']/1000)
            my_task.name = task['task-summary']['name']
            my_task.owner = task['task-summary']['actual-owner']
            my_task.status = task['task-summary']['status']
            my_task.subject = task['task-summary']['subject']
            my_task.description = task['task-summary']['description']
            my_task.data = task['task-summary']
            my_task.process.data = self.process_instance(task['task-summary']['process-instance-id'])
            my_task.process.deployment_id = task['task-summary']['deployment-id']
            my_task.process.id = my_task.process.data['process-id']
            my_task.process.instance_id = my_task.process.data['process-instance-id']
            my_task.process.start_on = Time.at(my_task.process.data['start']/1000)
            my_task.process.name = my_task.process.data['process-name']
            my_task.process.version = my_task.process.data['process-version']
            my_task.process.creator = my_task.process.data['identity']
            my_task.process.variables = self.process_instance_variables(my_task.process.deployment_id, my_task.process.instance_id)
            tasks << my_task
          end
        end
        
        return tasks
      end
  end
end