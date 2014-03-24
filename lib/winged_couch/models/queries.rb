module WingedCouch
  module Models

    # Module for querying on design views
    #
    module Queries

      # Main method for building queries to CouchDB design views
      #
      # @param view_name [String]
      #
      # @return [WingedCouch::QueryBuilder] query builder with configured path
      #
      # @example
      #   result = Model.view("cats").with_param("limit", 5).perform
      #   # => [#<Model _id: "...", _rev: "...", ...>, ... ]
      #   result.count
      #   # => 5
      #
      def view(view_name)
        view = Design::View.new(design_document, view_name)
        WingedCouch::Queries::ViewBuilder.new(view, self)
      end

    end
  end
end