module Specroutes::Constraints
  class BaseConstraint
    PATH_PARAMS_KEY = "action_dispatch.request.path_parameters"

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
        acc.store(*param.split('=',2))
        acc
      end
    end
  end
end
