module WingedCouch
  module Queries

    # Module for defining parameters for QueryBulder
    #
    # @see QueryBuilder
    #
    module DSL

      # @private
      PROCESSORS = {
        fixnum:  proc { |v| v.to_i },
        boolean: proc { |v| !!v },
        raw:     proc { |v| v },
        param:   proc { |v| to_param(v) }
      }

      extend self

      # Method for defining query parameter
      #
      # @param name [Symbol] name of query parameter
      # @param type [Symbol] type of query parameter value (used for type-casting)
      #
      # @example Basic usage:
      #   WingedCouch::Queries::QueryBuilder.parameter(:limit, :fixnum)
      #
      #   Model.build(view: "view_name").limit(10)
      #   # => this method will add "?limit=10" to the end of URL
      #
      # @example Available "type" values:
      #   :fixnum - using `to_i` method
      #   :boolean - uses double negation (!!)
      #   :raw - uses passed value as is
      #   :param - uses inspect/to_json method + encoding
      #
      def parameter(name, type)
        raise ArgumentError, "Unknown parameter type #{type}" unless PROCESSORS.has_key?(type)
        processor = PROCESSORS[type]
        define_method name do |value|
          with_param name, processor.call(value)
        end
      end

      # @private
      def to_param(value)
        value.is_a?(String) ? value.inspect : value.to_json
      end

    end
  end
end