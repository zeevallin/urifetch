require 'spec_helper'

describe Urifetch::Handler do
  
  describe '#initialize' do
    
    it 'should return Urifetch::Handler' do
      Urifetch::Handler.new(:default).should be_a_kind_of Urifetch::Handler
    end
    
    it 'should have a default value of a Hash on @handlers' do
      @handlers = Urifetch::Handler.new(:default).instance_variable_get(:@handlers)
      @handlers.should_not be_nil
      @handlers.should be_a_kind_of Hash
    end
    
  end
  
end