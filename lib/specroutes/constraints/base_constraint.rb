module Specroutes::Constraints
  class BaseConstraint
    PATH_PARAMS_KEY = "action_dispatch.request.path_parameters"

    include Specroutes::UtilityBelt::StateBasedEquality

    def matches?(_request)
      true
    end

    protected
    def as_param!(request, values={})
      params = request.send(:env)[PATH_PARAMS_KEY]
      params.merge!(values)
    end

    def query_params(request)
      query_string = request.original_fullpath.split('?', 2).last.to_s
      query_string.split(/[;&]/).reduce({}) do |acc, param|
        key, value = param.split('=',2)
        acc.store(key, value) if value
        acc
      end
    end

    def positional_params(request)
      query_string = request.original_fullpath.split('?', 2).last.to_s
      index = 0
      query_string.split(/[;&]/).reduce({}) do |acc, param|
        key, value = param.split('=',2)
        acc.store(key, index) unless value
        index += 1
        acc
      end
    end
  end
end
