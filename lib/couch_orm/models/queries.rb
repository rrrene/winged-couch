module CouchORM
  module Models

    # Module for querying on design views
    #
    module Queries

      # @private
      class QueryBuilderWrapper

        def method_missing(method_name, *args)
          @result = query_builder.send(method_name, *args)
          if method_name.to_s == "perform"
            process_result
          else
            self
          end
        end

        def process_result
          case @strategy
          when "view:map"
            @result["rows"].map { |attrs| @model.new(attrs["key"]) }
          when "view:map:reduce"
            @result["rows"].first["value"]
          else
            raise RuntimeError, "Unknown query strategy #{@strategy}"
          end
        end

        def with_model(model)
          @model = model
          self
        end

        def with_strategy(strategy)
          @strategy = strategy
          self
        end

        private

        def query_builder
          @query_builder ||= CouchORM::QueryBuilder.new
        end
      end

      # Main method for building queries to CouchDB design views
      #
      # @param options [Hash]
      # @option options [String] :view name of design view
      #
      # @return [CouchORM::QueryBuilder] query builder with configured path
      #
      # @example
      #   result = Model.build(view: "cats").with_param("limit", 5).perform
      #   # => [#<Model _id: "...", _rev: "...", ...>, ... ]
      #   result.count
      #   # => 5
      #
      def build(options = {})
        options.each do |key, value|
          return send("build_#{key}", value)
        end
      end

      private

      def query
        CouchORM::Models::Queries::QueryBuilderWrapper.new.with_model(self)
      end

      def build_view(view_name)
        query.
          with_strategy(find_strategy_for_view(view_name)).
          with_path("/_design/couch_orm/_view/#{view_name}").
          with_database(self.database)
      end

      def find_strategy_for_view(view_name)
        functions = database.design_views[view_name].keys
        case functions
        when ["map"]
          "view:map"
        when ["map", "reduce"]
          "view:map:reduce"
        else
          "unknown"
        end
      end
    end
  end
end