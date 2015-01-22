module Specroutes::Constraints
  class PositionalParamConstraint < BaseConstraint
    attr_reader :allowed_params

    def initialize(allowed_params)
      @allowed_params = allowed_params
    end

    def matches?(request)
      params = positional_params(request)
      hits = 0
      allowed_params.each_pair do |param, pos|
        actual_pos = params[param]
        return false if actual_pos != pos
      end
      true
    end
  end
end
