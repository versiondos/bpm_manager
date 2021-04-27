# Version Dos BPM Manager Gem
BPM Manager Gem for Red Hat jBPM

Feel free to fork, contribute &amp; distribute

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bpm_manager'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bpm_manager

Also do not forget to execute the initializer with:

    $ rails generate bpm_manager:install

## Usage

First configure properly the gem using the bpm_manager.rb file in 'config/initializers/bpm_manager.rb' or calling:

```ruby
BpmManager.configure do |config|
  config.bpm_url        => 'bpm.server.com'         # without http:// or https://
  config.bpm_url_suffix => '/business-central/rest' # could be also /jbpm-console/rest
  config.bpm_username   => 'foo'                    # your server username
  config.bpm_passowrd   => 'bar'                    # your password
  config.bpm_use_ssl    => false                    # use true for https
end
```

Then make an API call like this:

```ruby
result = BpmManager::RedHat.deployments()
```

## Quick Examples for Red Hat

```ruby
# Get all the Deployments
BpmManager::RedHat.deployments

# Get all the Tasks for an User ID
BpmManager::RedHat.tasks('foo@bar.com')

# Get all the Tasks with options (RedHat example). It supports all REST API options.
BpmManager::RedHat.tasks({:ownerId => 'foo@bar.com', :processInstanceId => 3})

# Get all the Process Instances
BpmManager::RedHat.process_instances

# Get the Process Instance with ID = 3
BpmManager::RedHat.process_instance(3)
```

## Quick Examples for Oracle

```ruby
# Get all Tasks
BpmManager::Oracle.tasks

# Get all the Tasks for an User ID
BpmManager::Oracle.tasks('foo@bar.com')
```

## Note

Tasks and Process structures includes a :data method in which returns the JSON raw data from server.
Oracle is only supported by a third-party REST API. The native API do not support all the required features.

## Contributing

1. Fork it ( https://github.com/versiondos/bpm_manager/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

BpmManager is released under the MIT License.
