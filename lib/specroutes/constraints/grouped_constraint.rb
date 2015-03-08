module Specroutes::Constraints
  class GroupedConstraint
    attr_reader :constraints

    def self.from(constraint)
      constraint.respond_to?(:constraints) ? constraint : new(constraint)
    end

    def initialize(*args)
      @constraints = args.flatten
    end

    def <<(constraint)
      constraints << constraint if constraint
    end

    def prepend!(constraint)
      @constraints = [constraint] + constraints if constraint
      self
    end

    def matches?(request)
      constraints.all? { |c| c.matches?(request) }
    end
  end
end
