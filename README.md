# BeatCoding BPM Manager Gem
BPM Manager Gem for RedHat jBPM &amp; Oracle BPM engines

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

First configure properly the gem using the bpm_manager.rb file in 'config/initializers/bpm_manager.rb' or calling

```ruby
BpmManager.configure do |config|
  config.bpm_vendor     => 'RedHat'           # or 'Oracle'
  config.bpm_url        => 'bpm.company.com'  # without http:// or https://
  config.bpm_username   => 'scott'
  config.bpm_passowrd   => 'tiger'
  config.bpm_use_ssl    => false              # use true for https
end
```

Then make an API call like this:

```ruby
result = BpmManager.deployments()
```

## Quick Examples


```ruby
# Get all the Deployments
BpmManager.deployments

# Get all the Tasks for an User ID
BpmManager.tasks('foo@bar.com')

# Get all the Tasks with options (RedHat example). It supports all REST API options.
BpmManager.tasks({:ownerId => 'foo@bar.com', :processInstanceId => 3})

# Get all the Process Instances
BpmManager.process_instances

# Get the Process Instance with ID = 3
BpmManager.process_instance(3)
```

## Contributing

1. Fork it ( https://github.com/BeatCoding/bpm_manager/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

BpmManager is released under the MIT License.