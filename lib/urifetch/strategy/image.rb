class Urifetch::Strategy::Image < Urifetch::Strategy::Base
  
  def process_request
        
    # Works for ["PCX", "PSD", "XPM", "TIFF", "XBM", "PGM", "PBM", "PPM", "BMP", "JPEG", "PNG", "GIF", "SWF"]
    
    # Preview File Source
    set :image, @request.base_uri.to_s
    set :url, @request.base_uri.to_s    
    
    # Title
    set :title, File.basename(@request.base_uri.to_s)
    
    # File Type
    set :mime_type, @request.meta['content-type']
    
    # File Size
    set :image_size, number_to_human_size(@request.size)
    
    unless get(:mime_type).match(/text\/html/i).nil?
      doc = Nokogiri::HTML.parse(@request)
              
      # Open Auth data
      if og = OpenGraph.parse(doc)
        set :url,         og.url,   override: true
        set :title,       og.title, override: true
        set :image,       og.image, override: true
      end
      
      unless set? :title
        t = doc.css('title').first
        set :title, t.nil? ? match_data[0] : t.content.strip
      end
      
    else
    
      # Image Size
      sizes = [nil,nil]
      3.times do |i|
        begin
          sizes = ImageSize.new(@request).get_size
        rescue NoMethodError => e
          sizes = ImageSize.new(@request.read).get_size
        end
        break if sizes != [nil,nil]
      end
    
      unless sizes == [nil,nil]
        set :image_height, sizes[1]
        set :image_width, sizes[0]
      end
    
    end
    
  end
  
end