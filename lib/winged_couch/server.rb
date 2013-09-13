require 'active_support/core_ext/module/delegation'

# Module for calling server-level methods
#
# @see http://wiki.apache.org/couchdb/Complete_HTTP_API_Reference
#
module WingedCouch
  module Server

    extend self

    delegate :get, :post, :update, :delete, to: WingedCouch::HTTP

    # Returns base information about CouchDB server
    #
    # @see http://wiki.apache.org/couchdb/HttpGetRoot
    #
    # @return Hash
    #
    def info
      get("/")
    end

    # Returns all dbs data
    #
    # @see http://wiki.apache.org/couchdb/HttpGetAllDbs
    #
    # @return Hash
    #
    def all_dbs
      get("/_all_dbs")
    end

    # Returns data about active tasks
    #
    # @see http://wiki.apache.org/couchdb/HttpGetActiveTasks
    #
    # @return Hash
    #
    def active_tasks
      get("/_active_tasks")
    end

    # Creates replication according to passed data
    #
    # @see http://wiki.apache.org/couchdb/Replication
    #
    # @param data [Hash]
    #
    # @option data [String] :source
    #   Identifies the database to copy revisions from. Requered field.
    # @option data [String] :target
    #   Identifies the database to copy revisions to. Requered field.
    # @option data [true, false] :cancel
    #   Include this property with a value of true to cancel an existing replication between the specified source and target
    # @option data [true, false] :continuous
    #   CouchDB can persist continuous replications over a server restart
    # @option data [true, false] :create_target
    #   A value of true tells the replicator to create the target database if it doesn't exist yet
    # @option data [Array<String>] :doc_ids
    #   Array of document IDs; if given, only these documents will be replicated
    # @option data [String] :filter
    #   Name of a filter function that can choose which revisions get replicated
    # @option data [String] :proxy
    #   Proxy server URL.
    # @option data [Hash] :query_params 
    #   Object containing properties that are passed to the filter function
    #
    # @return Hash response from CouchDB
    #
    def replicate(data)
      post("/replicate", data)
    end

    # Returns list of used generated UUIDs
    #
    # @see http://wiki.apache.org/couchdb/HttpGetUuids
    #
    # @param count [Fixnum] How many UUIDs to generate (optional, default 1)
    #
    # @return [Hash]
    #
    def uuids(count = 1)
      get("/_uuids?count=#{count}")
    end

    # Restarts the server, requires admin privileges
    #
    def restart
      post("/_restart")
    end

    # Returns server statistics
    #
    # @return Hash
    #
    def stats
      get("/_stats")
    end

    # Returns the tail of the server's log file, requires server admin privileges.
    #
    # @see http://wiki.apache.org/couchdb/HttpGetLog
    #
    # @param data [Hash]
    #
    # @option data [Fixnum] :bytes How many bytes to return from the tail of the log file(optional, default 1000)
    # @option data [Fixnum] :offset How many bytes to offset the returned tail of the log file (optional, default 0)
    #
    # @return String multiline log string
    #
    def log(data = {})
      bytes  = data.fetch(:bytes, 1000)
      offset = data.fetch(:offset, 0)
      RestClient.get("#{WingedCouch.url}/_log?bytes=#{bytes}&offset=#{offset}")
    end
  end
end