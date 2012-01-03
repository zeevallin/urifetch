require 'hashie/mash'
require 'addressable/uri'
require 'pry'

module Urifetch
  
  DEFAULT_MATCH_STRING = /(.*)/i
  DEFAULT_STRATEGY = :default
  
  autoload :Handler,   'urifetch/handler'
  autoload :Strategy, 'urifetch/strategy'
  autoload :Response, 'urifetch/response'
  
  @@handler = Handler.new(DEFAULT_STRATEGY)
  
  def self.fetch_from(url,args={})
    find_strategy_from(url).execute!
  end
  
  def self.find_strategy_from(url,args={})
    if valid_url?(url)
      @@handler.find(url)
    else
      raise ArgumentError, "invalid url"
    end
  end
  
  def self.valid_url?(url)
    !(url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix).nil?
  end
  
  def self.register(&block)
    @@handler.instance_eval(&block)
  end
  
end

Urifetch.register do
  match /(.*)/i, :test
end

Urifetch::Strategy.layout(:test) do
end

# Urifetch::Strategy.layout(:default) do
# end