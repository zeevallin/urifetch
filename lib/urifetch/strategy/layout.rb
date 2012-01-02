module Urifetch

  class Strategy
    
    class Layout
      
      attr_reader :before, :success, :failure
      
      def initialize(args={},&block)
        instance_exec(args,&block) if block_given?
        @success  = Proc.new {} if @success.nil?
        @failure  = Proc.new {} if @failure.nil?
        @before   = Proc.new {} if @before.nil?
      end
      
      def after_success(&block)
        raise ArgumentError unless block_given?
        @success = block
      end
      
      def after_failure(&block)
        raise ArgumentError unless block_given?
        @failure = block
      end
      
      def before_request(&block)
        raise ArgumentError unless block_given?
        @before = block
      end
      
    end
    
  end

end