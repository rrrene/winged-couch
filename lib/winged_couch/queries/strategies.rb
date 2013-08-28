module WingedCouch
  module Queries

    # @private
    module Strategies

      protected

      def map_strategy(response, model)
        response["rows"].map do |data|
          attrs = data.values_at("key", "value", "values").detect { |v| v.is_a?(Hash) }
          model.new(attrs)
        end
      end

      def map_reduce_strategy(response, model)
        response["rows"].first["value"]
      end

    end
  end
end