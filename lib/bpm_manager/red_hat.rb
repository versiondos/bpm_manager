require "rest-client"
require "json"
require "ostruct"

module BpmManager
  module RedHat
    # Gets all server deployments
    def self.deployments()
      return JSON.parse(RestClient.get(BpmManager.uri('/deployment'), :accept => :json))
    end
    
    # Creates a new Process
    def self.create_process(deployment_id, process_definition_id, opts = {})
      RestClient.post(URI.encode(BpmManager.uri('/runtime/' + deployment_id.to_s + '/process/' + process_definition_id.to_s + '/start' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&')))), :headers => {:content_type => :json, :accept => :json})
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
    def self.process_instance_variables(process_instance_id)
      begin
        result = Hash.new
        JSON.parse(RestClient.get(BpmManager.uri('/history/instance/' + process_instance_id.to_s + '/variable'), :accept => :json))['historyLogList'].each{|e| result[e['variable-instance-log']['variable-id']] = e['variable-instance-log']['value']}
        
        return result
      rescue
        return {}
      end
    end
    
    # Gets all tasks, optionally you could specify an user id
    def self.tasks(user_id = "")
      self.structure_task_data(JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (user_id.empty? ? '' : '?taskOwner=' + user_id)), :accept => :json)))
    end
    
    # Gets all tasks with options
    def self.tasks_with_opts(opts = {})
      self.structure_task_data(JSON.parse(RestClient.get(BpmManager.uri('/task/query' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&'))), :accept => :json)))
    end
    
    # Assigns a Task for an User
    def self.assign_task(task_id, user_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/delegate?targetEntityId=' + user_id.to_s)), :headers => {:content_type => :json, :accept => :json})
    end

    # Gets all the information for a Task ID
    def self.task_query(task_id)
      JSON.parse(RestClient.get(BpmManager.uri('/task/' + task_id.to_s), :accept => :json))
    end
    
    # Starts a Task
    def self.start_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/start')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Releases a Task
    def self.release_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/release')), :headers => {:content_type => :json, :accept => :json})
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
    
    # Skips a Task
    def self.skip_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/skip')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Completes a Task
    def self.complete_task(task_id, opts = {})
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/complete' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&')))), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Completes a Task as Administrator
    def self.complete_task_as_admin(task_id, opts = {})
      self.release_task(task_id)
      self.start_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/complete' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&')))), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Fails a Task
    def self.fail_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/fail')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Exits a Task
    def self.exit_task(task_id)
      RestClient.post(URI.encode(BpmManager.uri('/task/' + task_id.to_s + '/exit')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Gets the Process History
    def self.get_history(process_definition_id = "")
      if process_definition_id.empty?
        JSON.parse(RestClient.get(BpmManager.uri('/history/instances'), :accept => :json))
      else
        JSON.parse(RestClient.get(BpmManager.uri('/history/process/' + process_definition_id.to_s), :accept => :json))
      end
    end
    
    # Clears all the History --WARNING: Destructive action!--
    def self.clear_all_history()
      RestClient.post(URI.encode(BpmManager.uri('/history/clear')), :headers => {:content_type => :json, :accept => :json})
    end
    
    # Gets the SLA for a Process Instance
    def self.get_task_sla(task_instance_id, process_sla_hours = 0, task_sla_hours = 0, warning_offset_percent = 20)
      my_task = self.tasks_with_opts('taskId' => task_instance_id).first
      
      unless my_task.nil?
        sla = OpenStruct.new(:task => OpenStruct.new, :process => OpenStruct.new)

        # Calculates the process sla
        sla.process.status = calculate_sla(my_task.process.start_on, process_sla_hours, warning_offset_percent)
        sla.process.status_name = (calculate_sla(my_task.process.start_on, process_sla_hours, warning_offset_percent) == 0) ? 'ok' : (calculate_sla(my_task.process.start_on, process_sla_hours, warning_offset_percent) == 1 ? 'warning' : 'due')
        sla.process.percent = calculate_sla_percent(my_task.process.start_on, process_sla_hours, warning_offset_percent)
        
        # Calculates the task sla
        sla.task.status = calculate_sla(my_task.task.created_on, task_sla_hours, warning_offset_percent)
        sla.task.status_name = (calculate_sla(my_task.created_on, task_sla_hours, warning_offset_percent) == 0) ? 'ok' : (calculate_sla(my_task.created_on, task_sla_hours, warning_offset_percent) == 1 ? 'warning' : 'due')
        sla.task.percent = calculate_sla_percent(my_task.created_on, task_sla_hours, warning_offset_percent)
      else
        sla = nil
      end
      
      return sla
    end
    
    # Private class methods
    def self.calculate_sla(start, sla_hours=0, offset=20)
      unless sla_hours > 0
        (start.to_f + ((sla_hours.to_f * 7*24*60*60))*((100-offset)/100)) <= Time.now.utc.to_f ? 0 : ((start.to_f + (sla_hours.to_f * 7*24*60*60) <= Time.now.utc.to_f) ? 1 : 2)
      else
        0
      end
    end
    private_class_method :calculate_sla
    
    def self.calculate_sla_percent(start, sla_hours=0, offset=20)
      percent = OpenStruct.new
      total = Time.now.utf.to_f - start.to_f
      
      percent.green = sla_hours > 0 ? (start.to_f + ((sla_hours.to_f * 7*24*60*60)) * ((100-offset)/100)) / total * 100 : 100
      percent.yellow = sla_hours > 0 ? (start.to_f + ((sla_hours.to_f * 7*24*60*60)) / total * 100) - green : 0
      percent.red = sla_hours > 0 ? 100 - yellow - green : 0
      
      return percent
    end
    private_class_method :calculate_sla_percent
    
    private
      def self.structure_task_data(input)
        tasks = []
        
        unless input['taskSummaryList'].nil? || input['taskSummaryList'].empty?
          input['taskSummaryList'].each do |task|
            my_task = OpenStruct.new
            my_task.process = OpenStruct.new
            my_task.id = task['task-summary']['id']
            my_task.process_instance_id = task['task-summary']['process-instance-id']
            my_task.parent_id = task['task-summary']['parent_id']
            my_task.created_on = Time.at(task['task-summary']['created-on']/1000)
            my_task.active_on = Time.at(task['task-summary']['activation-time']/1000)
            my_task.name = task['task-summary']['name']
            my_task.form_name = self.task_query(task['task-summary']['id'])['form-name']
            my_task.creator = self.task_query(task['task-summary']['id'])['taskData']['created-by']
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
            my_task.process.variables = self.process_instance_variables(my_task.process.instance_id)
            tasks << my_task
          end
        end
        
        return tasks
      end
  end
end