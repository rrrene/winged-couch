require 'active_support/core_ext/module/delegation'

module WingedCouch
  module Design
    class View

      attr_accessor :design_document, :view_name
      delegate :database, to: :design_document

      def initialize(design_document, view_name)
        @design_document, @view_name = design_document, view_name
      end

      def source
        design_document.data.fetch(:views, {})[view_name]
      end

      # @private
      def strategy
        case source.keys
        when ["map"]           then "view:map"
        when ["map", "reduce"] then "view:map:reduce"
        else "unknown"
        end
      end

      class << self
        def create(design_document, view_name, view_type, text)
          data = { views: { view_name =>  { view_type => text } } }
          design_document.data.deep_merge!(data)
          design_document.save
          self.new(design_document, view_name)
        end

        alias_method :from, :new
      end

      private

      def url
        "/_design/winged_couch/#{view_name}"
      end

    end
  end
end