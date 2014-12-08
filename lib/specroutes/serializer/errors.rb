module Specroutes::Serializer
  module Errors
    class Error < StandardError; end
    class UnknownDatatypeError < Error
      def initialize(datatype=nil)
        text = datatype && ": #{datatype}"
        super("Unknown datatype for XSD-representation#{text}")
      end
    end
  end
end
