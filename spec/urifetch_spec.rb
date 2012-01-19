require 'spec_helper'

describe Urifetch do
  
  describe 'self.fetch_from' do
    
    it 'should return a Urifetch::Response' do
      Urifetch.fetch_from(Urifetch::Test::UrlHelpers.generate_valid_url).should be_a_kind_of(Urifetch::Response)
    end
    
    it 'should raise an error if url is invalid according to configuration' do
      -> { Urifetch.fetch_from(Urifetch::Test::UrlHelpers.generate_invalid_url) }.should raise_error ArgumentError, "invalid url"
    end
    
  end
  
  describe 'self.find_strategy_from' do
    
    it 'should an instance of Urifetch::Strategy' do
      Urifetch.find_strategy_from("http://www.google.com").should be_an_instance_of Urifetch::Strategy
    end
    
  end
  
  describe 'strategy' do
    
    describe 'default' do
      
      it 'should return title and favicon for valid path' do
        @response = Urifetch.fetch_from("http://www.youtube.com")
        @response.data.should have_key(:title)
        @response.data.should have_key(:favicon)
      end
      
      it 'should return title and NOT favicon for valid path' do
        @response = Urifetch.fetch_from("http://www.google.com")
        @response.data.should have_key(:title)
        @response.data.should_not have_key(:favicon)
      end

    end
    
    describe 'image' do
      
      it 'should return image properties and file name for valid png file' do
        @url = "http://www.google.com/intl/en_com/images/srpr/logo3w.png"
        @title = "logo3w.png"
        @match_id = "http://www.google.com/intl/en_com/images/srpr/logo3w.png"
        @mime_type = "image/png"
        @image_size = [275, 95]
      end
      
      it 'should return image properties and file name for valid jpg file' do
        @url = "http://i.imgur.com/ab9Gd.jpg"
        @title = "ab9Gd.jpg"
        @match_id = "http://i.imgur.com/ab9Gd.jpg"
        @mime_type = "image/jpeg"
        @image_size = [492, 362]
      end
      
      it 'should return image properties and file name for valid gif file' do
        @url = "http://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"
        @title = "Rotating_earth_%28large%29.gif"
        @match_id = "http://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"
        @mime_type = "image/gif"
        @image_size = [400, 400]
      end
      
      it 'should return image properties and file name for valid bmp file' do
        @url = "http://www.gonmad.co.uk/satnav/bmp_blank.bmp"
        @title = "bmp_blank.bmp"
        @match_id = "http://www.gonmad.co.uk/satnav/bmp_blank.bmp"
        @mime_type = "image/bmp"
        @image_size = [16, 16]
      end
      
      it 'should return image properties and file name for valid gif file even though the initial minetype is html' do
        @url = "http://en.wikipedia.org/wiki/File:Sunflower_as_gif_small.gif"
        @title = "Sunflower_as_gif_small.gif"
        @match_id = "http://upload.wikimedia.org/wikipedia/commons/e/e2/Sunflower_as_gif_small.gif"
        @mime_type = "image/gif"
        @image_size = [250, 297]
      end
      
      after(:each) do
        @response = Urifetch.fetch_from(@url)

        # Check Title
        @response.data.should have_key(:title)
        @response.data[:title].should == @title
        
        # Check Match ID
        @response.data.should have_key(:match_id)
        @response.data[:match_id].should == @match_id
        
        # Check FileType
        @response.data.should have_key(:mime_type)
        @response.data[:mime_type].should == @mime_type
        
        # Check ImageSize
        @response.data.should have_key(:image_size)
        @response.data[:image_size].should == @image_size
      end
      
    end
    
  end
  
end
