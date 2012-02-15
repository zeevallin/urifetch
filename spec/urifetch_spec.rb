require 'spec_helper'

describe Urifetch do
  
  it 'should return a response' do
    mlfw = Urifetch.fetch("http://mylittlefacewhen.com/f/2446/") #.should be_a(Urifetch::Response)
    goog = Urifetch.fetch("http://www.google.com") #.should be_a(Urifetch::Response)
    tube = Urifetch.fetch("http://www.youtube.com/watch?v=xPfMb50dsOk")
    jpeg = Urifetch.fetch("http://www.dreamincode.net/forums/uploads/monthly_05_2010/post-380028-12747928967239.jpg.pagespeed.ce.yRppR_j7ae.jpg")
  end
  
end
