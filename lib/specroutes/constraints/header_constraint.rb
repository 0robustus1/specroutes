module Specroutes::Constraints
  class HeaderConstraint < BaseConstraint
    attr_accessor :header, :value

    def initialize(header, value)
      self.header = header
      self.value = value
      super()
    end

    def matches?(request)
      if value
        key_value_matches?(request)
      else
        existence_matches?(request)
      end
    end

    def key_value_matches?(request)
      request.headers[header] == value
    end

    def existence_matches?(request)
      request.headers.has_key?(header)
    end
  end
end
