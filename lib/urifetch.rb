require 'hashie'
require 'open-uri'
require 'nokogiri'
require 'image_size'
require 'stringio'
require 'addressable/uri'
require 'active_support/inflector'
require 'timeout'

require 'action_view'
include ActionView::Helpers::NumberHelper

require 'pry'

module Urifetch
  
  autoload :Response, 'urifetch/response'
  autoload :Strategy, 'urifetch/strategy'
  autoload :Router,   'urifetch/router'
  autoload :Version,  'urifetch/version'

  autoload :OpenGraph, 'urifetch/ext/opengraph'
  
  @@router = Router.new()
  
  def self.fetch(url,args={})
    if valid_url?(url)
      uri = Addressable::URI.heuristic_parse(url.to_s)
      @@router.find(uri).execute!
    else
      raise ArgumentError, "Invalid URL"
    end
  end
  
  def self.valid_url?(url)
    # Validates URL according to Cloudsdale.org standards
    !(url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix).nil?
  end
  
  def self.route(args={},&block)
    @@router = Router.new(args) do
      instance_eval(&block)
    end
  end
  
end

Urifetch.route do
  match /(?<image>(?<match_id>\.(?<file_type>PCX|PSD|XPM|TIFF|XBM|PGM|PBM|PPM|BMP|JPEG|JPG||PNG|GIF|SWF))$)/i, :image, strategy_class: 'Urifetch::Strategy::Image'
end

