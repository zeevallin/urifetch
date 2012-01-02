require 'spec_helper'

describe Urifetch::Strategy do

  describe 'self.layouts' do
    
    it 'should return an Hashie::Mash' do
      Urifetch::Strategy.layouts.should be_a_kind_of Hashie::Mash
    end
    
  end

  describe 'self.layout' do
    
    it 'should return a Urifetch::Strategy::Layout instance and make it accessible through .layouts' do
      @layout = Urifetch::Strategy.layout(:test) do; end
      @layout.should be_an_instance_of Urifetch::Strategy::Layout
      Urifetch::Strategy.layouts[:test].should == @layout
    end
    
  end
  
  describe 'self.apply' do
    
    it 'should return an instance of Urifetch::Strategy' do
      Urifetch::Strategy.apply(:test).should be_an_instance_of Urifetch::Strategy
    end
    
  end
  
  describe 'self.apply!' do
    
    it 'should return an instance of Urifetch::Response' do
      Urifetch::Strategy.apply!(:test).should be_an_instance_of Urifetch::Response
    end
    
  end
  
  before do
    @strategy = Urifetch::Strategy.new(:test,"".match(//i))
  end

  describe '#initialize' do
    
    it 'should return an error if layout was not found' do
      -> { Urifetch::Strategy.new(:not_found,"".match(//i)) }.should raise_error(RuntimeError, /no matching layouts found/i)
    end
    
    it 'should contain match data as a MatchData object' do
      @strategy.match_data.should be_a_kind_of MatchData
    end
    
    it 'should have a layout as a Urifetch::Strategy::Layout' do
      @strategy.layout.should be_an_instance_of Urifetch::Strategy::Layout
    end
    
  end
  
  describe 'execute!' do
    
    it 'should return an instance of Urifetch::Response' do
      @strategy.execute!.should be_an_instance_of Urifetch::Response
    end
    
  end

end