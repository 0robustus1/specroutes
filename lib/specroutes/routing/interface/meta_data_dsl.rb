module Specroutes::Routing
  module Interface
    class MetaDataDSL
      attr_accessor :route_specification, :match_block

      def initialize(route_specification, &block)
        self.route_specification = route_specification
        instance_eval(&block) if block
      end

      def accept(mime_type, constraint: false, accept_allstar: false)
        accepts << mime_type
        mime_constraints << [mime_type, accept_allstar] if constraint
      end

      def reroute_on_mime(mime, to:, accept_allstar: false)
        accept(mime)
        klass = Specroutes::Constraints::MimeTypeConstraint
        reroute(to, klass.new(mime, accept_allstar: accept_allstar))
      end

      def reroute_on_header(header:, value:, to:)
        klass = Specroutes::Constraints::HeaderConstraint
        reroute(to, klass.new(header, value))
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

      def status_codes
        %w(200)
      end
    end
  end
end
