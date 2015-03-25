module Specroutes::Routing
  module Interface
    class ResourcePart
      attr_accessor :path

      def initialize(path)
        self.path = path
      end

      def clean_path
        path.sub(%r{^/+}, '').sub(%r{/+$}, '')
      end

      def doc(lang: 'en', title:, body: '')
        docs[lang] = {lang: lang, title: title, body: body}
      end

      def meta
        docs.values
      end

      private
      def docs
        @docs ||= {}
      end
    end
  end
end
