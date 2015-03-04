module Specroutes::Routing
  module Interface
    class MetaDataDSL
      attr_accessor :route_specification, :match_block

      def initialize(route_specification, &block)
        self.route_specification = route_specification
        instance_eval(&block) if block
      end

      def accept(mime_type, constraint: false)
        accepts << mime_type
        mime_constraints << mime_type if constraint
      end

      def doc(lang: 'en', title:, body: '')
        docs[lang] = {lang: lang, title: title, body: body}
      end

      def match_block(&block)
        self.match_block = block
      end

      def accepts
        @accepts ||= []
      end

      def mime_constraints
        @mime_constraints ||= []
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
