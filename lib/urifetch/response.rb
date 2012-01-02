module Urifetch

  class Response
    
    attr_reader :status, :strategy, :data
    
    def initialize(args={})
      @status       = args[:status]       || ['0','']
      @strategy     = args[:strategy]     || Strategy.new(:test,"".match(//))
      @data         = args[:data]         || Hashie::Mash.new
    end
    
  end

end