module Specroutes::Constraints
  class MimeTypeConstraint < BaseConstraint
    attr_accessor :mime_types

    def initialize(*mime_types)
      self.mime_types = mime_types.flatten.map { |m| Mime::Type.lookup(m) }
      super()
    end

    # In some cases request.accepts == [nil] (e.g. cucumber tests),
    # in these cases we will default to true.
    def matches?(request)
      highest_mime = request.accepts.first
      highest_mime ? mime_types.any? { |m| highest_mime == m } : true
    end
  end
end
