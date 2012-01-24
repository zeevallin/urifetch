module Urifetch
  
  require 'open-uri'
  require 'nokogiri'
  require 'image_size'
  require 'stringio'
  
  class Strategy
    
    autoload :Layout, 'urifetch/strategy/layout'
    
    @@layouts = Hashie::Mash.new
    def self.layouts
      @@layouts
    end
    
    attr_reader :layout, :match_data, :layout_key, :uri, :filehead, :skip_request
    
    def initialize(layout_key,match_data,args={})
      @skip_request = args[:skip_request] || false
      @layout_key = layout_key
      @match_data = match_data
      @layout = @@layouts[layout_key]
      raise "no matching layouts found on #{layout_key}" unless @layout
    end
    
    def self.layout(layout_key,&block)
      layouts[layout_key] = Layout.new(layout_key,&block)
    end
    
    def self.apply(layout_key,args={})
      m_data = args[:with] || "".match(//)
      Strategy.new(layout_key,m_data)
    end
    
    def self.apply!(layout_key,args={})
      apply(layout_key,args).execute!
    end
    
    def execute!
      run_before!
      unless skip_request
        begin
          @uri = Addressable::URI.heuristic_parse(match_data.string)
          request = open(@uri.to_s,'rb')
          status  = request.status
          run_on_success!(request)
        rescue OpenURI::HTTPError => error
          status  = (error.message.split(" ",2))
          run_on_failure!(error)
        rescue SocketError => error
          status  = (["400","Bad Request"])
          run_on_failure!(error)
        rescue Errno::ENOENT => error
          status  = (["404","File not Found"])
          run_on_failure!(error)
        rescue Errno::ECONNREFUSED => error
          status  = (["401","Unauthorized"])
          run_on_failure!(error)
        rescue RuntimeError => error
          status  = (["400","Bad Request"])
          run_on_failure!(error)
        rescue Exception => e
          status  = (["500","Server Error",e])
        end
      else
        status  = (["200","OK"])
      end
      return Response.new(status: status, strategy: self, data: @data)
    end
    
    private
    
    def run_before!
      instance_exec(&layout.before) unless layout.before.nil?
    end
    
    def run_on_success!(request)
      @uri = request.base_uri
      instance_exec(request,&layout.success) unless layout.before.nil?
    end
    
    def run_on_failure!(error)
      instance_exec(error,&layout.failure) unless layout.before.nil?
    end
    
    def data
      @data ||= Hashie::Mash.new
    end
    
  end
  
end