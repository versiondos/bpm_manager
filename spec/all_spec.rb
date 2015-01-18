require 'spec_helper'

describe "#config" do
  before :each do
    @config = BpmManager::config()
    @deployments = BpmManager::get_deployments()
  end
  
  it "should be a Hash" do
    @config.should be_an_instance_of Hash
  end
    
  it 'should not be empty' do
    @config.size.should > 0
  end
end