module Urifetch
  module Test
    module UrlHelpers
      
      def self.generate_valid_url
        "http://www.urifetch.com/path/to/somewhere.jpg?q=hello"
      end
      
      def self.generate_invalid_url
        "this-is-invalid"
      end
      
    end
  end
end