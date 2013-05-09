# AdobeConnect

[![Build Status](https://secure.travis-ci.org/zachpendleton/adobe_connect.png)](http://travis-ci.org/zachpendleton/adobe_connect)

AdobeConnect is a Ruby Gem that provides a wrapper for interacting with the
Adobe Connect API that (hopefully) sucks less than dealing with the Adobe
Connect API itself.

It provides methods that correspond to each of the Connect API calls, so you
can do awesome stuff like:

```ruby
connect = AdobeConnect::Service.new
connect.log_in
connect.principal_list #=> returns a list of users
```

## Installation

Add this line to your application's Gemfile:

    gem 'adobe_connect', '1.0.0'

And then run:

    $ bundle install

Or install it yourself as:

    $ gem install adobe_connect

## Get started

You can get started by running `adobe_connect_console` in your terminal. This
will open up a new Pry session with all of the AdobeConnect classes loaded.

```ruby
# start by configuring it with a username, password, and domain.
AdobeConnect::Config.declare do
  username 'test@example.com'
  password 'password'
  domain   'http://connect.example.com'
end

connect = AdobeConnect::Service.new

# log in so you have a session
connect.log_in #=> true

# get crazy with your bad self
connect.principal_list(filter_login: 'test@example.com')
connect.sco_contents_by_url(url_path: '/whatever/')
```

## Details

Once you've instantiated a Service instance, it has methods for all of the API
calls that Connect supports. Just replace your Connect action and parameter
name dashes with underscores. e.g. `principal-update` becomes
`principal_update` and `first-name` becomes `first_name`.

Responses are AdobeConnect::Response objects, and respond to normal Nokogiri
methods for querying XML. They also have a `fetch()` method for getting headers
and a `status` method for getting back the status code of your request.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
