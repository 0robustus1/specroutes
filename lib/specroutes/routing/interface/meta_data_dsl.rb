module Specroutes::Routing
  module Interface
    class MetaDataDSL
      class Error < ::StandardError; end
      class NotInCorrectBlock < Error; end

      attr_accessor :route_specification, :match_block

      def initialize(route_specification, &block)
        self.route_specification = route_specification
        instance_eval(&block) if block
      end

      def accept(mime_type, constraint: false, accept_allstar: false, &block)
        accepts << mime_type
        mime_constraints << [mime_type, accept_allstar] if constraint
        for_mime(mime_type, &block) if block
      end

      def reroute_on_mime(mime, to:, accept_allstar: false, &block)
        accept(mime)
        klass = Specroutes::Constraints::MimeTypeConstraint
        reroute(to, klass.new(mime, accept_allstar: accept_allstar))
        for_mime(mime, &block) if block
      end

      def reroute_on_header(header:, value:, to:)
        klass = Specroutes::Constraints::HeaderConstraint
        reroute(to, klass.new(header, value))
      end

      def request(json:)
        raise NotInCorrectBlock, "request wasn't called in accept, or reroute_* block" unless @mime
        request_representations[@mime] = json
      end

      def response(status:, json: nil)
        raise NotInCorrectBlock, "response wasn't called in accept, or reroute_* block" unless @mime
        response_representations[status.to_s] ||= {}
        response_representations[status.to_s][@mime] = json if json
      end

      def reroute(target, constraint)
        reroutes << {target: target, constraint: constraint}
      end

      def doc(lang: 'en', title:, body: '')
        docs[lang] = {lang: lang, title: title, body: body}
      end

      def match_block(&block)
        self.match_block = block
      end

      def accepts
        @accepts ||= Set.new
      end

      def mime_constraints
        @mime_constraints ||= []
      end

      def reroutes
        @reroutes ||= []
      end

      def docs
        @docs ||= {}
      end

      def request_representations
        @request_representations ||= {}
      end

      def response_representations
        @response_representations ||= {}
      end

      def for_mime(mime)
        old_mime = @mime
        @mime = mime
        yield
        @mime = old_mime
      end

      def status_codes
        if response_representations.any?
          response_representations.keys.map(&:to_s)
        else
          %w(200)
        end
      end
    end
  end
end
