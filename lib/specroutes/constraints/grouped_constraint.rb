module Specroutes::Constraints
  class GroupedConstraint
    attr_reader :constraints

    def initialize(*args)
      @constraints = args.flatten
    end

    def matches?(request)
      constraints.all? { |c| c.matches?(request) }
    end
  end
end
