module CouchORM

  # @see QueryBuilder
  module Queries

    # Class for building low-level queries to CouchDB database
    #
    # @example
    #   builder = CouchORM::BaseBuilder.new
    #   builder.
    #    with_database(Profile.database).
    #    with_path("/_design/couch-orm/all").
    #    with_param("limit", 100).
    #    with_http_method("get").
    #    perform
    #   # => { "count" => 100, "records" => [...] }
    #
    class BaseBuilder

      chain_accessor :database
      chain_accessor :http_method, default: "get"
      chain_accessor :path
      chain_accessor :params, as: :hash, chain_name: :param

      # Performs http request with specified parameters
      #
      # @return [Hash] response
      #
      # @see #with_database
      # @see #with_path
      # @see #with_param
      # @see #with_http_method
      #
      def perform(options = {})
        validate
        database.send(http_method, *query)
      end

      private

      def attributes
        {
          database:    database,
          path:        path,
          params:      params,
          http_method: http_method
        }
      end

      def validate
        attributes.each do |attr_name, attr_value|
          raise RuntimeError, "#{attr_name} is blank" unless attr_value
        end
      end

      def query
        if http_method == "get"
          url = params.empty? ? path : "#{path}?#{encoded_params}"
          [url]
        else
          [path, params]
        end
      end

      def encoded_params
        params.map { |key, value| "#{key}=#{value}" }.join("&")
      end
    end
  end
end