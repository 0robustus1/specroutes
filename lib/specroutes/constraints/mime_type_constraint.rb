module Specroutes::Constraints
  class MimeTypeConstraint < BaseConstraint
    attr_accessor :mime_types, :accept_allstar

    def initialize(*mime_types, accept_allstar: false)
      self.mime_types = mime_types.flatten.map { |m| Mime::Type.lookup(m) }
      self.accept_allstar = accept_allstar
      super()
    end

    # In some cases request.accepts == [nil] (e.g. cucumber tests).
    # This seems to be the result of a */* Accept header.
    # setting accept_allstar to true will allow matching this.
    def matches?(request)
      highest_mime = request.accepts.first
      if accept_allstar
        highest_mime ? mime_types.any? { |m| highest_mime == m } : true
      else
        mime_types.any? { |m| highest_mime == m }
      end
    end
  end
end
