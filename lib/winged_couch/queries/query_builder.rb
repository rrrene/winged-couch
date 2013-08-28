require 'winged_couch/queries/base_builder'
require 'winged_couch/queries/strategies'
require 'winged_couch/queries/dsl'

module WingedCouch
  module Queries

    # Class building high-level queries to CouchDB
    #
    class QueryBuilder < BaseBuilder

      include Strategies
      extend DSL

      chain_accessor :model
      chain_accessor :strategy

      # Performs request to CouchDB
      #
      # @param options [Hash]
      # @option options [Object] :raw (false) returns raw response when true-equivalent passed
      #
      # @return [Array<WingedCouch::Model>] when raw: false passed
      # @return [Hash] raw data when raw: true passed
      #
      def perform(options = {})
        @result = super

        if options[:raw]
          @result
        else
          process_strategy[@result, @model] rescue @result
        end
      end

      parameter :descending,     :boolean
      parameter :endkey,         :param
      parameter :endkey_docid,   :raw
      # available only for reduce views
      parameter :group,          :boolean
      # available only for reduce views
      parameter :group_level,    :fixnum
      parameter :include_docs,   :boolean
      parameter :inclusive_end,  :boolean
      parameter :key,            :param
      parameter :limit,          :fixnum
      parameter :reduce,         :boolean
      parameter :skip,           :fixnum
      parameter :stale,          :raw
      parameter :startkey,       :param
      parameter :startkey_docid, :raw
      parameter :update_seq,     :boolean

      private

      def process_strategy
        case strategy
        when "view:map"        then method(:map_strategy)        # see Strategies
        when "view:map:reduce" then method(:map_reduce_strategy) # see Strategies
        else
          raise RuntimeError, "Unknown query strategy #{@strategy}"
        end
      end


    end

  end
end