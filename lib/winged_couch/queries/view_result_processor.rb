module WingedCouch
  module Queries
    class ViewResultProcessor

      module MapViewProcessor
        def self.process(raw_result, model)
          raw_result["rows"].map do |row|
            model.new(row["value"])
          end
        end
      end

      module MapReduceProcesor
        def self.process(raw_result, model)
          raw_result["rows"].first["value"]
        end
      end

      MAPPING = {
        "view:map" => MapViewProcessor,
        "view:map:reduce" => MapReduceProcesor
      }

      attr_reader :view, :model, :raw_result

      def initialize(view, model, raw_result)
        @view = view
        @model = model
        @raw_result = raw_result
      end

      def result
        internal_processor.process(raw_result, model)
      end

      private

      def internal_processor
        MAPPING[view.strategy] or raise "Unknown view type #{view.strategy}"
      end

    end
  end
end