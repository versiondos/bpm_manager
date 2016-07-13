require "rest-client"
require "json"
require "ostruct"

module BpmManager
  module RedHat
    # Gets all server deployments
    def self.deployments()
      JSON.parse(BpmManager.server['/deployment'].get)
    end
    
    # Gets all available processes
    def self.processes()
      JSON.parse(BpmManager.server['/deployment/processes'].get)['processDefinitionList']
    end

    # Creates a new Process
    def self.create_process(deployment_id, process_definition_id, opts = {})
      BpmManager.server['/runtime/' + deployment_id.to_s + '/process/' + process_definition_id.to_s + '/start'].post(opts)
    end
    
    # Gets all Process Instances
    def self.process_instances
      JSON.parse(BpmManager.server['/history/instances'].get)
    end
    
    # Gets all the runtime processes with query options
    def self.processes_query_with_opts(opts = {})
      JSON.parse(BpmManager.server['/query/runtime/process/' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&'))].get)['processInstanceInfoList']
    end
    
    # Gets a Process Instance
    def self.process_instance(process_instance_id)
      JSON.parse(BpmManager.server['/history/instance/' + process_instance_id.to_s].get)
    end

    # Gets a Process Instance Nodes
    def self.process_instance_nodes(process_instance_id)
      JSON.parse(BpmManager.server['/history/instance/' + process_instance_id.to_s + '/node'].get)['historyLogList']
    end
    
    # Gets a Process Instance Variables
    def self.process_instance_variables(process_instance_id)
      begin
        result = Hash.new
        JSON.parse(BpmManager.server['/history/instance/' + process_instance_id.to_s + '/variable'].get)['historyLogList'].each{|e| result[e.first.second['variable-id']] = e.first.second['value']}
        
        return result
      rescue
        return {}   # same result as not found record in jbpm
      end
    end
    
    # Gets the Process image as SVG    
    def self.process_image(deployment_id, process_definition_id, process_id = '')
      begin
        BpmManager.server['/runtime/' + deployment_id.to_s + '/process/' + process_definition_id.to_s + '/image' + ((process_id.to_s.nil? || process_id.to_s.empty?) ? '' : '/' + process_id.to_s)].get
      rescue
        return ''   # returns an empty string in case of error
      end
    end
    
    # Gets all tasks, optionally you could specify an user id
    def self.tasks(user_id = '')
      self.structure_task_data(JSON.parse(BpmManager.server['/task/query?taskOwner=' + user_id].get))
    end
    
    # Gets all tasks with options
    def self.tasks_with_opts(opts = {})
      self.structure_task_data(JSON.parse(BpmManager.server['/task/query' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&'))].get))
    end
    
    # Assigns a Task for an User
    def self.assign_task(task_id, user_id)
      BpmManager.server['/task/' + task_id.to_s + '/delegate'].post(:targetEntityId => user_id.to_s)
    end

    # Gets all the information for a Task ID
    def self.task_query(task_id)
      JSON.parse(BpmManager.server['/task/' + task_id.to_s].get)
    end
    
    # Gets all the runtime Tasks with query options
    def self.task_query_with_opts(opts = {})
      JSON.parse(BpmManager.server['/query/runtime/task/' + (opts.empty? ? '' : '?' + opts.map{|k,v| k.to_s + '=' + v.to_s}.join('&'))].get)['taskInfoList']
    end
  
    # Starts a Task
    def self.start_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/start'].post({})
    end
    
    # Releases a Task
    def self.release_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/release'].post({})
    end
    
    # Stops a Task
    def self.stop_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/stop'].post({})
    end
    
    # Suspends a Task
    def self.suspend_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/suspend'].post({})
    end
    
    # Resumes a Task
    def self.resume_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/resumes'].post({})
    end
    
    # Skips a Task
    def self.skip_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/skip'].post({})
    end
    
    # Completes a Task
    def self.complete_task(task_id, opts = {})
      BpmManager.server['/task/' + task_id.to_s + '/complete'].post(opts)
    end
    
    # Completes a Task as Administrator
    def self.complete_task_as_admin(task_id, opts = {})
      self.release_task(task_id)
      self.start_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/complete'].post(opts)
    end
    
    # Fails a Task
    def self.fail_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/fail'].post({})
    end
    
    # Exits a Task
    def self.exit_task(task_id)
      BpmManager.server['/task/' + task_id.to_s + '/exit'].post({})
    end
    
    # Gets the Process History
    def self.get_history(process_definition_id = "")
      if process_definition_id.empty?
        JSON.parse(BpmManager.server['/history/instances'].get)
      else
        JSON.parse(BpmManager.server['/history/process/' + process_definition_id.to_s].get)
      end
    end
    
    # Clears all the History --WARNING: Destructive action!--
    def self.clear_all_history()
      BpmManager.server['/history/clear'].post({})
    end
    
    # Gets the SLA for a Process Instance
    def self.get_task_sla(task_instance_id, process_sla_hours = 0, task_sla_hours = 0, warning_offset_percent = 20)
      my_task = self.tasks_with_opts('taskId' => task_instance_id).first
      
      unless my_task.nil?
        sla = OpenStruct.new(:task => OpenStruct.new, :process => OpenStruct.new)
        
        # Calculates the process sla
        sla.process.status = calculate_sla(my_task.process.start_on, process_sla_hours, warning_offset_percent)
        sla.process.status_name = (calculate_sla(my_task.process.start_on, process_sla_hours, warning_offset_percent) == 0) ? 'ok' : (calculate_sla(my_task.process.start_on, process_sla_hours, warning_offset_percent) == 1 ? 'warning' : 'due')
        sla.process.percentages = calculate_sla_percent(my_task.process.start_on, process_sla_hours, warning_offset_percent)
        
        # Calculates the task sla
        sla.task.status = calculate_sla(my_task.created_on, task_sla_hours, warning_offset_percent)
        sla.task.status_name = (calculate_sla(my_task.created_on, task_sla_hours, warning_offset_percent) == 0) ? 'ok' : (calculate_sla(my_task.created_on, task_sla_hours, warning_offset_percent) == 1 ? 'warning' : 'due')
        sla.task.percentages = calculate_sla_percent(my_task.created_on, task_sla_hours, warning_offset_percent)
      else
        sla = nil
      end
      
      return sla
    end
    
    # Private class methods
    def self.calculate_sla(start, sla_hours = 0.0, offset = 20)
      hours = sla_hours.to_f * 3600   # Converts to seconds and calculates warning offset
      warn = start.utc + hours * ((100.0 - offset) / 100)
      total = start.utc + hours
      
      # Returns the status      
      Time.now.utc <= warn ? 0 : ( warn < Time.now.utc && Time.now.utc <= total ? 1 : 2 )
    end
    private_class_method :calculate_sla
    
    def self.calculate_sla_percent(start, sla_hours = 0.0, offset = 20)
      sla_hours = sla_hours * 3600.0   # converts to seconds
      offset_pcg = (100.0 - offset) / 100.0
      percent = OpenStruct.new
      
      unless sla_hours < 1 # it's zero or negative
        if Time.now.utc > (start.utc + sla_hours) # Ruby Red
          total = (Time.now.utc - start.utc).to_f
          percent.green  = (sla_hours * offset_pcg / total * 100).round(2)
          percent.yellow = ((sla_hours / total * 100) - percent.green).round(2)
          percent.red    = (100 - percent.yellow - percent.green).round(2)
        else   # Still Green
          total = sla_hours
          percent.green  = Time.now.utc <= start.utc + total * offset_pcg ? ((100-offset) - (((start.utc + total * offset_pcg) - Time.now.utc) * 100).to_f / (total * offset_pcg).to_f).round(2) : 100 - offset
          percent.yellow = Time.now.utc <= start.utc + total * offset_pcg ? 0.0 : (offset - (start.utc + total - Time.now.utc).to_f * 100 / (total * offset_pcg).to_f).round(2)
          percent.red    = 0.0
        end
        
        # Safe to 0.0
        percent.green  = percent.green < 0.0 ? 0.0 : percent.green
        percent.yellow = percent.yellow < 0.0 ? 0.0 : percent.yellow
        percent.red    = percent.red < 0.0 ? 0.0 : percent.red
      else
        percent.green  = 100.0
        percent.yellow = 0.0
        percent.red    = 0.0
      end
      
      return percent
    end
    private_class_method :calculate_sla_percent
    
    private
      def self.structure_task_data(input)
        tasks = []
        
        unless input['taskSummaryList'].nil? || input['taskSummaryList'].empty?
          input['taskSummaryList'].each do |task|
            my_task = OpenStruct.new
            my_task.id = task['id']
            my_task.name = task['name']
            my_task.subject = task['subject']
            my_task.description = task['description']
            my_task.status = task['status']
            my_task.priority = task['priority']
            my_task.skippable = task['skippable']
            my_task.created_on = Time.at(task['created-on']/1000)
            my_task.active_on = Time.at(task['activation-time']/1000)
            my_task.process_instance_id = task['process-instance-id']
            my_task.process_id = task['process-id']
            my_task.process_session_id = task['process-session-id']
            my_task.deployment_id = task['deployment-id']
            my_task.quick_task_summary = task['quick-task-summary']
            my_task.parent_id = task['parent_id']
            my_task.form_name = self.task_query(task['id'])['form-name']
            my_task.creator = self.task_query(task['id'])['taskData']['created-by']
            my_task.owner = task['actual-owner']
            my_task.data = task

            my_task.process = OpenStruct.new
            my_task.process.data = self.process_instance(task['process-instance-id'])
            my_task.process.deployment_id = task['deployment-id']
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