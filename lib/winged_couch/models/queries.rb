module WingedCouch
  module Models

    # Module for querying on design views
    #
    module Queries

      # Main method for building queries to CouchDB design views
      #
      # @param options [Hash]
      # @option options [String] :view name of design view
      #
      # @return [WingedCouch::QueryBuilder] query builder with configured path
      #
      # @example
      #   result = Model.build(view: "cats").with_param("limit", 5).perform
      #   # => [#<Model _id: "...", _rev: "...", ...>, ... ]
      #   result.count
      #   # => 5
      #
      def build(options = {})
        view, show = options.values_at(:view, :show)
        return build_view(view) if view
        return build_show(show) if show
      end

      private

      def default_query
        WingedCouch::Queries::QueryBuilder.new.
          with_model(self).
          with_database(self.database)
      end

      def build_view(view_name)
        view = WingedCouch::View.new(database, view_name)
        default_query.
          with_strategy(view.strategy).
          with_path("/_design/winged_couch/_view/#{view_name}")
      end

    end
  end
end