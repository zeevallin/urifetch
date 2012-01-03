module Urifetch
  
  
  class Handler
    
    def initialize(strategy_key,&block)
      @handlers = {}
      raise ArgumentError "strategy ('#{strategy.class}') needs to be a 'Symbol'" unless strategy_key.kind_of?(Symbol)
      @strategy_key = strategy_key || DEFAULT_STRATEGY
      yield if block_given?
    end
    
    def find(url,previous_match=nil)
      previous_match = url.match(DEFAULT_MATCH_STRING) if previous_match.nil?
      @handlers.each do |key,val|
        m = url.match(key)
        return val.find(url,m) if m != 0 and !m.nil?
      end
      return Urifetch::Strategy.apply(@strategy_key, with: previous_match)
    end
    
    private
    
    def match(string,strategy,&block)
      raise ArgumentError "matcher ('#{key.class}') needs to be either 'String' or 'Regexp'" unless [String,Regexp].include?(string.class)
      @dealers[key] = Handler.new(strategy,&block)
    end
    
  end
  
end