require 'hashie/mash'
require 'addressable/uri'

module Urifetch
  
  DEFAULT_MATCH_STRING = /(.*)/i
  DEFAULT_STRATEGY = :default
  
  autoload :Handler,  'urifetch/handler'
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
end

Urifetch::Strategy.layout(:test) do
  
  before_request do
  end
  
  after_success do |request|
  end
  
  after_failure do |error|
  end
  
end

Urifetch::Strategy.layout(:default) do
  
  before_request do 
  end
  
  after_success do |request|
    doc = Nokogiri::HTML(request)

    # Title
    title = doc.css('title').first
    data.title = title.nil? ? match_data[0] : title.content.strip
    
    # Favicon
    favicon = doc.css('link[rel="shortcut icon"], link[rel="icon shortcut"], link[rel="shortcut"], link[rel="icon"]').first
    favicon = favicon.nil? ? nil : favicon['href'].strip
    if favicon
      if favicon.match(/^https?:\/\//i).nil?
        favicon = uri.scheme + "://" + uri.host + favicon
      end
      data.favicon = favicon
    end
  end
  
  after_failure do |error|
  end
  
end