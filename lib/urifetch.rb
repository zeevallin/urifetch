require 'hashie/mash'
require 'addressable/uri'
#require 'pry'

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
  match /\.(PCX|PSD|XPM|TIFF|XBM|PGM|PBM|PPM|BMP|JPEG|JPG||PNG|GIF|SWF)$/i, :image
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

Urifetch::Strategy.layout(:image) do
  
  before_request do
  end
  
  after_success do |request|
    # Works for ["PCX", "PSD", "XPM", "TIFF", "XBM", "PGM", "PBM", "PPM", "BMP", "JPEG", "PNG", "GIF", "SWF"]
    
    # Match ID
    data.match_id = request.base_uri.to_s
    
    # Title
    data.title = File.basename(request.base_uri.to_s)
    
    # File Type
    data.mime_type = request.meta['content-type']
    
    unless data.mime_type.match(/text\/html/i).nil?
      doc = Nokogiri::HTML(request)
      t = data.title.sub(/^.*\:/i,'')
      t2 = t.sub(/\./i,"\\.")
      src = doc.search('img').map(&:attributes).map{|h|h["src"].to_s}.reject{|u|u.match(/#{t2}/i).nil?}.first
      src.sub!(/^\/\//i,'http://')
      if src
        data.title = t
        @uri = Addressable::URI.heuristic_parse(src)
        data.match_id = @uri.to_s
        request = open(@uri.to_s,'rb')
        data.mime_type = request.meta['content-type']
      end
    end
    
    # Image Size
    data.image_size = [nil,nil]
    3.times do |i|
      begin
        data.image_size = ImageSize.new(request).get_size
      rescue NoMethodError => e
        data.image_size = ImageSize.new(request.read).get_size#  unless e.message.match(/undefined method `type' for/).nil?
      end
      break if data.image_size != [nil,nil]
    end
  end
  
  after_failure do |error|
    # File Type
    data.mime_type = 'unknown'
    
    # Image Size
    data.image_size = [0,0]
  end
  
end