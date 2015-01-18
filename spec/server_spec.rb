require 'spec_helper'

describe "#uri" do
  before :each do
    @server = BpmManager::Server.new()
    @uri = @server.uri('/test')
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
    @server = BpmManager::Server.new
    @config = @server.config()
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
    @server = BpmManager::Server.new()
    @deployments = @server.deployments()
  end
  
  it "must return something" do
    expect(@deployments.length).to be > 0
  end
end