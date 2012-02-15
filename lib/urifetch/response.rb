module Urifetch

  class Response
    
    attr_accessor :status, :strategy_key, :data
    
    def initialize(status,strategy_key,data)
      @status         = status
      @strategy_key   = strategy_key
      @data           = data
    end
    
    def to_h
      @data
    end
    
    def to_json
      to_h.to_json
    end
    
  end

end