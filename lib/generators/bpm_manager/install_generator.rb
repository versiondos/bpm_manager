require 'rails/generators'

module BpmManager
  class InstallGenerator < Rails::Generators::Base
    desc "Generates the BpmManager configuration file"
    
    def self.source_root
      @source_root ||= File.expand_path(File.dirname(__FILE__))
    end
    
    def copy_initializer
      copy_file 'bpm_manager.rb', 'config/initializers/bpm_manager.rb'
    end    
  end
end
