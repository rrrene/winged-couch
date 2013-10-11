require 'winged_couch/queries/dsl'

module WingedCouch
  module Queries

    # Class building high-level queries to CouchDB
    #
    class QueryBuilder < BaseBuilder

      extend DSL

      chain_accessor :model
      chain_accessor :strategy

      # Performs request to CouchDB
      #
      # @return [WingedCouch::Queries::Result>]
      #
      def perform
        @result ||= Result.new(model, strategy, super)
      end

      parameter :descending,     :boolean
      parameter :endkey,         :param
      parameter :endkey_docid,   :raw
      parameter :group,          :boolean # available only for reduce views
      parameter :group_level,    :fixnum  # available only for reduce views
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

      def initialize_copy(other)
        super
        @result = nil
      end

    end

  end
end
