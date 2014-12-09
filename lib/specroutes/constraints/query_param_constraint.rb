module Specroutes::Constraints
  class QueryParamConstraint < BaseConstraint
    attr_reader :allowed_params

    def initialize(allowed_params)
      @allowed_params = allowed_params
    end

    def matches?(request)
      Set.new(query_params(request).keys) == Set.new(allowed_params)
    end
  end
end
