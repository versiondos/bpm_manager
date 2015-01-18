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

1. First configure properly the gem using the bpm_manager.rb file in 'config/initializers/bpm_manager.rb'
2. Assign the Server with:

    $ @server = BpmManager.new

3. Make a call:

    $ result = @server.get_deployments()

## Contributing

1. Fork it ( https://github.com/BeatCoding/bpm_manager/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
