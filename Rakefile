# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:test, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'

require './lib/urifetch/version'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.version = Uriversal::Version::STRING
  gem.name = "urifetch"
  gem.homepage = "http://github.com/zeeraw/Urifetch"
  gem.license = "MIT"
  gem.summary = "Match URL's to request strategies and retrieve them in a usable format."
  gem.description = "Urifetch allows you to fetch data from any URL using pattern matching. The library allows for dynamically adding match handlers as well as build your own strategies."
  gem.email = "philip@vallin.se"
  gem.authors = ["Philip Vieira"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "urifetch #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
