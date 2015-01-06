module Specroutes::UtilityBelt
  module StateBasedEquality
    def hash
      equality_state.hash
    end

    def ==(other)
      other.class == self.class && other.equality_state == equality_state
    end

    alias_method :eql?, :==

    protected
    # Classes which include the module
    # should provide an equality_state method.
    def equality_state
      instance_variables.sort.map { |name| instance_variable_get(name) }
    end
  end
end
