module Urifetch
  
  class Router
    
    attr_reader :routes
    
    def initialize(options={},&block)
      
      options = default_options = {
        strategy_key:    "base",
        class_name:   "Urifetch::Strategy::Base"
      }.merge(options)
      
      @routes = Hash.new(options)
      
      instance_eval(&block) if block_given?
      
      @routes[/(?<base>(?<match_id>.*))/i] = @routes[""]
    end
    
    def find(uri)
      
      # Tries to find a match
      match_data = @routes.keys.map{|r|r.match(uri.to_s)}.reject{|r|r.nil?}[0]
      
      # Fetches route data for given regex
      route_data = @routes[match_data.regexp]
            
      begin
        # Spawns strategy instance by constantizing strategy name
        class_name = route_data[:strategy_class] || "Urifetch::Strategy::" + route_data[:strategy_key].classify
        strategy = class_name.constantize.new(uri,match_data,route_data)
        
      rescue NameError
        # Spawns base strategy instance
        strategy = Strategy::Base.new(uri,match_data,route_data)
      end
      
      return strategy
      
    end
    
    private
    
    def match(string,strategy_key,args={})
      
      # Raises an ArgumentError if a non supported filetype is supplied.
      raise ArgumentError "matcher ('#{string.class}') needs to be either 'String' or 'Regexp'" unless [String,Regexp].include?(string.class)
      raise ArgumentError "strategy_key ('#{strategy_key.class}') needs to be either 'String' or 'Symbol'" unless [String,Symbol].include?(strategy_key.class)
      # Stores the arguments in memory
      routes[string] = { strategy_key: strategy_key.to_s }.merge(args)
      
    end
    
  end
  
end