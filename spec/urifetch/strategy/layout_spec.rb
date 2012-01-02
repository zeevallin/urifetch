require 'spec_helper'

describe Urifetch::Strategy::Layout do
  
  before do
    @layout = Urifetch::Strategy::Layout.new do
      
      after_success do
        some_method
      end
      
      after_failure do
        some_method
      end
      
      before_request do
        some_method
      end
      
    end
  end
  
  describe '#initialize' do
    
    it 'should set on_success to empty proc unless proc is defined' do
      @layout.success.should be_an_instance_of Proc
    end
    
    it 'should set on_failure to empty proc unless proc is defined' do
      @layout.failure.should be_an_instance_of Proc
    end
    
    it 'should set before to empty proc unless proc is defined' do
      @layout.before.should be_an_instance_of Proc
    end
    
  end
  
  describe 'after_success' do
    
    it 'should overwrite the value proc' do
      proc = @layout.instance_variable_get(:@success)
      @layout.after_success do
        some_method
      end
      proc.should_not eq(@layout.instance_variable_get(:@success))
    end
    
    it 'should overwrite the value proc' do
      proc = @layout.instance_variable_get(:@failure)
      @layout.after_failure do
        some_method
      end
      proc.should_not eq(@layout.instance_variable_get(:@failure))
    end
    
    it 'should overwrite the value proc' do
      proc = @layout.instance_variable_get(:@before)
      @layout.before_request do
        some_method
      end
      proc.should_not eq(@layout.instance_variable_get(:@before))
    end
    
  end
  
end