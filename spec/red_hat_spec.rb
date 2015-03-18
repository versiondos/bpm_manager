require 'spec_helper'
require 'ruby-debug'

describe BpmManager do
  before :all do
    BpmManager.configure do |config|
      config.bpm_url = "bpm.beatcoding.com"
      config.bpm_url_suffix = "/jbpm-console/rest"
      config.bpm_username = "Administrator"
      config.bpm_password = "bc-power"
      config.bpm_use_ssl = false
    end
  end
  
  describe "#uri" do
    before :each do
      @uri = BpmManager.uri('/test')
    end
    
    it "expect to be a String" do
      expect(@uri).to be_an_instance_of String
    end
  
    it "expect to not be nil" do
      expect(@uri).not_to eq(nil)
    end
  end
  
  describe "#configuration" do
    before :each do
      @config = BpmManager.configuration
    end
    
    it "should be a class of type Configuration" do
      expect(@config).to be_an_instance_of BpmManager::Configuration
    end
    
    it 'must have all the accesors' do
      expect(@config.methods.include? :bpm_url).to be true
      expect(@config.methods.include? :bpm_username).to be true
      expect(@config.methods.include? :bpm_password).to be true
      expect(@config.methods.include? :bpm_use_ssl).to be true
    end
  end

  describe "RedHat" do
    describe "#deployments" do
      before :each do
        @deployments = BpmManager::RedHat.deployments
      end
      
      it "must return something" do
        expect(@deployments.length).to be > 0
      end
    end
  
    describe "#tasks" do
      before :each do
        @tasks = BpmManager::RedHat.tasks('ariel@beatcoding.com')
      end
      
      it "task should include the all attributes" do
        expect(@tasks.first.methods).to include(:id)
        expect(@tasks.first.methods).to include(:process_instance_id)
        expect(@tasks.first.methods).to include(:parent_id)
        expect(@tasks.first.methods).to include(:created_on)
        expect(@tasks.first.methods).to include(:active_on)
        expect(@tasks.first.methods).to include(:name)
        expect(@tasks.first.methods).to include(:owner)
        expect(@tasks.first.methods).to include(:status)
        expect(@tasks.first.methods).to include(:subject)
        expect(@tasks.first.methods).to include(:description)
        expect(@tasks.first.methods).to include(:data)
        
        expect(@tasks.first.process.methods).to include(:id)
        expect(@tasks.first.process.methods).to include(:deployment_id)
        expect(@tasks.first.process.methods).to include(:instance_id)
        expect(@tasks.first.process.methods).to include(:start_on)
        expect(@tasks.first.process.methods).to include(:name)
        expect(@tasks.first.process.methods).to include(:version)
        expect(@tasks.first.process.methods).to include(:creator)
        expect(@tasks.first.process.methods).to include(:data)
      end      
    end
    
    describe "#tasks_with_opts" do
      before :each do
        @tasks = BpmManager::RedHat.tasks_with_opts(:processInstanceId => 1)
      end
      
      it "task should include the all attributes" do
        expect(@tasks.first.methods).to include(:id)
        expect(@tasks.first.methods).to include(:process_instance_id)
        expect(@tasks.first.methods).to include(:parent_id)
        expect(@tasks.first.methods).to include(:created_on)
        expect(@tasks.first.methods).to include(:active_on)
        expect(@tasks.first.methods).to include(:name)
        expect(@tasks.first.methods).to include(:owner)
        expect(@tasks.first.methods).to include(:status)
        expect(@tasks.first.methods).to include(:subject)
        expect(@tasks.first.methods).to include(:description)
        expect(@tasks.first.methods).to include(:data)
        
        expect(@tasks.first.process.methods).to include(:id)
        expect(@tasks.first.process.methods).to include(:deployment_id)
        expect(@tasks.first.process.methods).to include(:instance_id)
        expect(@tasks.first.process.methods).to include(:start_on)
        expect(@tasks.first.process.methods).to include(:name)
        expect(@tasks.first.process.methods).to include(:version)
        expect(@tasks.first.process.methods).to include(:creator)
        expect(@tasks.first.process.methods).to include(:data)
      end      
    end
  
    describe "#process_instances" do
      before :each do
        @processes = BpmManager::RedHat.process_instances
      end
      
      it "must return something" do
        expect(@processes.length).to be > 0
      end
    end
  
    describe "#process_instance" do
      before :each do
        @process = BpmManager::RedHat.process_instance(1)
      end
      
      it "must return something" do
        expect(@process.length).to be > 0
      end
    end
  
    describe "#process_instance_variables" do
      before :each do
        @variables = BpmManager::RedHat.process_instance_variables('com.beatcoding.simpletask:SimpleTask:1.0',1)
      end
      
      it "must return something" do
        expect(@variables.length).to be > 0 unless @variables.nil?
      end
    end
  
    describe "#assign_task" do
      before :each do
        @result = BpmManager::RedHat.assign_task(1,'ariel@beatcoding.com')
      end
      
      it "must return something" do
        expect(@result.length).to be > 0
      end
    end
  
    describe "#release_task" do
      before :each do
        @result = BpmManager::RedHat.release_task(1)
      end
      
      it "must return something" do
        expect(@result.length).to be > 0
      end
    end
    
    # describe "#complete_task" do
    #   before :each do
    #     @result = BpmManager::RedHat.complete_task(1)
    #   end
      
    #   it "must return something" do
    #     expect(@result.length).to be > 0
    #   end
    # end
  end
end