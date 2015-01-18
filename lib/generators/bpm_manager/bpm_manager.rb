BpmManager.configure do |config|
  # Sets the BPM engine vendor [RedHat || Oracle]
  config.bpm_vendor = "RedHat"

  # Sets the BPM url address without http:// or https://
  config.bpm_url = "bpm.company.com"
  
  # Sets the BPM connection username
  config.bpm_username = "scott"

  # Sets the BPM connection password
  config.bpm_password = "tiger"

  # Turns on|off the SSL protocol for the server (false is default)
  config.bpm_use_ssl = false
end