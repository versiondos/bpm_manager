require 'spec_helper'

describe "BpmManager" do
  before :all do
    BpmManager.configure do |config|
      config.bpm_vendor = "RedHat"
      config.bpm_url = "bpm.company.com"
      config.bpm_username = "scott"
      config.bpm_password = "tiger"
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
      expect(@config.methods.include? :bpm_vendor).to be true
      expect(@config.methods.include? :bpm_url).to be true
      expect(@config.methods.include? :bpm_username).to be true
      expect(@config.methods.include? :bpm_password).to be true
      expect(@config.methods.include? :bpm_use_ssl).to be true
    end
  end
  
  describe "#deployments" do
    before :each do
      @deployments = BpmManager.deployments
    end
    
    it "must return something" do
      expect(@deployments.length).to be > 0
    end
  end

  describe "#tasks" do
    before :each do
      @tasks = BpmManager.tasks('foo@bar.com')
    end
    
    it "must return something" do
      expect(@tasks.length).to be > 0
    end
  end

  describe "#tasks_with_opts" do
    before :each do
      @tasks = BpmManager.tasks_with_opts(:ownerId => 'foo@bar.com', :taskId => 1)
    end
    
    it "must return something" do
      expect(@tasks.length).to be > 0
    end
  end

  describe "#process_instances" do
    before :each do
      @processes = BpmManager.process_instances
    end
    
    it "must return something" do
      expect(@processes.length).to be > 0
    end
  end

  describe "#process_instance" do
    before :each do
      @process = BpmManager.process_instance(1)
    end
    
    it "must return something" do
      expect(@process.length).to be > 0
    end
  end

  describe "#process_instance_simplified" do
    before :each do
      @process = BpmManager.process_instance_simplified(1)
    end
    
    it "must return something" do
      expect(@process.length).to be > 0
    end
  end

  describe "#process_instance_variables" do
    before :each do
      @variables = BpmManager.process_instance_variables('package.process:1.0',1)
    end
    
    it "must return something" do
      expect(@variables.length).to be > 0
    end
  end
end