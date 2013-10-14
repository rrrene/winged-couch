module WingedCouch
  module Models

    # Module for querying on design views
    #
    module Queries

      def has_views(*view_names)
        view_names.each do |view_name|
          define_singleton_method view_name do
            view(view_name)
          end
        end
      end


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
      def view(view_name)
        view = Design::View.new(design_document, view_name)
        default_query.
          with_strategy(view.strategy).
          with_path("/_design/winged_couch/_view/#{view_name}")
      end

      private

      def design_document
        Design::Document.from(database)
      end

      def default_query
        WingedCouch::Queries::QueryBuilder.new.
          with_model(self).
          with_database(self.database)
      end

    end
  end
end