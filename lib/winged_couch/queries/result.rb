module WingedCouch
  module Queries
    class Result

      FIELDS = %w(total_rows offset rows update_seq)

      attr_accessor :data

      def initialize(model, strategy, data)
        @model, @strategy, @data = model, strategy, data
      end

      def records(options = {})
        @records ||= strategy_proc.call
      end

      alias_method :result, :records

      FIELDS.each do |field|
        define_method field do
          data[field]
        end
      end

      private

      def strategy_proc
        case @strategy
        when "view:map"        then method(:map_strategy)        # see Strategies
        when "view:map:reduce" then method(:map_reduce_strategy) # see Strategies
        else
          raise RuntimeError, "Unknown query strategy #{@strategy}"
        end
      end

      def map_strategy
        rows.map do |row|
          attrs = row.values_at("key", "value", "values").detect { |v| v.is_a?(Hash) }
          @model.new(attrs)
        end
      end

      def map_reduce_strategy
        rows.first["value"]
      end

    end
  end
end