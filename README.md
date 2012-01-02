# Urifetch

Match URL's to request strategies and retrieve them in a usable format. Urifetch allows you to fetch data from any URL using pattern matching. The library allows for dynamically adding match handlers as well as build your own strategies.

## Install

##### Simply install them gem through RubyGems
> gem install urifetch

#### Or through Bundler
Gemfile:
> gem 'urifetch'
Run:
> ~$ bundle install

## Basic Usage

#### Require the library
> require 'urifetch'

#### Start using

> response = Urifetch.fetch_from("http://www.github.com")
> response.status
> => ["200","ok"]
> response.data
> => { title: 'Google' }


## Contributing to Urifetch
 
##### Coming soon...


## Copyright

Copyright (c) 2012 Philip Vieira. See LICENSE.txt for
further details.

