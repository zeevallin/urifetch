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
  
end
