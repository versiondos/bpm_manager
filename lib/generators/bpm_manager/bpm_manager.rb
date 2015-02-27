BpmManager.configure do |config|
  # Sets the BPM URL or IP address without the http:// or https://
  config.bpm_url = "bpm.server.com"

  # Sets the URL suffix like: '/business-central/rest' or '/jbpm-console/rest' 
  config.bpm_url_suffix = "/jbpm-console/rest"
  
  # Sets the BPM connection username
  config.bpm_username = "foo"

  # Sets the BPM connection password
  config.bpm_password = "bar"

  # Turns on|off the SSL protocol for the server (false is default)
  config.bpm_use_ssl = false
end