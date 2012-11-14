module Urifetch

  module Strategy
    
    class Base
      
      attr_reader :uri, :match_data, :route_data, :response
      
      def initialize(uri,match_data,route_data={})
        @uri = uri
        @match_data = match_data
        @route_data = route_data
        @response = Response.new(['0',''],route_data[:strategy_key],{})
      end
      
      def execute!
        perform_request
        process_request if response.status == ["200","OK"]
        response
      end
      
      def perform_request
        begin
          timeout(30) { @request  = open(@uri.to_s,'rb') }
          set_status  @request.status
        rescue OpenURI::HTTPError => error
          set_status error.message.split(" ",2)
        rescue SocketError => error
          set_status ["400","Bad Request"]
        rescue Errno::ENOENT => error
          set_status ["404","File not Found"]
        rescue Errno::ECONNREFUSED => error
          set_status ["401","Unauthorized"]
        rescue Errno::EADDRINUSE
          set_status ["401","Unauthorized"]
        rescue RuntimeError => error
          set_status ["400","Bad Request"]
        rescue Exception => e
          set_status ["500","Server Error",e]
        rescue TimeOutError
          set_status ["408","Request Timeout"]
        else
          set_status ["200","OK"]
        end
      end
      
      def process_request
                
        # Start by setting the URI
        set :url, uri.to_s.sub(/\/$/,"")
        
        doc = Nokogiri::HTML.parse(@request)
                
        # Open Auth data
        if og = OpenGraph.parse(doc)
          set :url,         og.url.to_s.sub(/\/$/,""), override: true
          set :title,       og.title
          set :image,       og.image
          set :description, og.description
        end
                
        # Custom CSS data
        unless set? :title
          t = doc.css('title').first
          set :title, t.nil? ? match_data[0] : t.content.strip
        end
        
        favicon = doc.css('link[rel="shortcut icon"], link[rel="icon shortcut"], link[rel="shortcut"], link[rel="icon"]').first
        favicon = favicon.nil? ? nil : favicon['href'].strip
        if favicon
          if favicon.match(/^https?:\/\//i).nil?
            favicon = uri.scheme + "://" + uri.host.sub(/\/$/,"") + "/" + favicon.sub(/^\//,"")
          end
          set :favicon, favicon
        end
        
        # Fallback Image
        image = doc.css('img').first
        image = image.present? ? image['src'].strip : nil
        if image
          if image.match(/^https?:\/\//i).nil?
            image = uri.scheme + "://" + uri.host.sub(/\/$/,"") + "/" + image.sub(/^\//,"")
          end
          set :image, image unless get(:image).present?
        end
        
      end
      
      private
      
      def set_status(status_array)
        response.status = status_array
      end
      
      def get(key)
        response.data[key.to_s]
      end
            
      def set(key,value,args={})
        response.data[key.to_s] = value if (args[:override] == true) or response.data[key.to_s].nil? unless value.nil?
      end
      
      def set?(key)
        !response.data[key.to_s].nil?
      end
            
    end
    
  end

end