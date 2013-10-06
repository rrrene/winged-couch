require 'active_support/core_ext/module/delegation'

module WingedCouch
  module Design

    # Class for working with design views
    #
    class View

      attr_accessor :design_document, :view_name
      delegate :database, to: :design_document

      def initialize(design_document, view_name)
        @design_document, @view_name = design_document, view_name
      end

      # Returns source code of view
      #
      # @return [Hash] in format { "map" => "function(doc) { ... }", "reduce" => "..." }
      #
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

        # Creates design view
        #
        # @param design_document [WingedCouch::Design::Document]
        # @param view_name [String] name of name
        # @param view_type [String] "map" or "reduce"
        # @param text [String] source code of view
        #
        # @return [WingedCouch::Design::View] created view
        #
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