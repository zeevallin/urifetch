require 'spec_helper'

describe Urifetch::Response do

  describe '#initialize' do
    
    before do
      @response = Urifetch::Response.new()
    end
  
    it 'should contain status as an array' do
      @response.status.should_not be_nil
      @response.status.should be_a_kind_of(Array)
    end
  
    it 'should contain the strategy used when matching' do
      @response.strategy.should_not be_nil
      @response.strategy.should be_a_kind_of(Urifetch::Strategy)
    end
  
    it 'should contain data as a hashie/mash' do
      @response.data.should_not be_nil
      @response.data.should be_a_kind_of(Hashie::Mash)
    end
    
  end

end