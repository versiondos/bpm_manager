require 'spec_helper'

describe "BpmManager" do
  before :all do
    BpmManager.configure({ :bpm_vendor => 'RedHat', :bpm_url => 'bpm.beatcoding.com', :bpm_username => 'Administrator', :bpm_password => 'bc-power' })
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
  
  describe "#config" do
    before :each do
      @config = BpmManager.config
    end
    
    it "should be a Hash" do
      expect(@config).to be_an_instance_of Hash
    end
    
    it 'should not be empty' do
      expect(@config.length).to be > 0
    end
    
    it 'must have all the keys' do
      expect(@config.has_key? :bpm_vendor).to be true
      expect(@config.has_key? :bpm_url).to be true
      expect(@config.has_key? :bpm_username).to be true
      expect(@config.has_key? :bpm_password).to be true
      expect(@config.has_key? :bpm_use_ssl).to be true
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
      @tasks = BpmManager.tasks('ariel@beatcoding.com')
    end
    
    it "must return something" do
      expect(@tasks.length).to be > 0
    end
  end

  describe "#tasks_with_opts" do
    before :each do
      @tasks = BpmManager.tasks_with_opts({:ownerId => 'ariel@beatcoding.com', :id => 6})
    end
    
    it "must return something" do
      expect(@tasks.length).to be > 0
    end
  end
end