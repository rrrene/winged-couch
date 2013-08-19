require 'logger'

module CouchORM

  # Main configuration module
  #
  # @example Usage:
  #   CouchORM.setup do |config|
  #     config.host = "couch-db-host.com"
  #     config.port = 1234
  #   end
  #
  #   CouchORM.host
  #   # => "couch-db-host.com"
  #
  #   CouchORM.port
  #   # => 1234
  #
  #   CouchORM.reset_configuration!
  #   # => nil
  #
  #   CouchORM.host
  #   # => "127.0.0.1"
  #
  #   CouchORM.port
  #   # => 5984
  #
  module Configuration

    attr_writer :host
    attr_writer :port
    attr_writer :logger

    # Returns CouchDB host
    #
    # @return [String]
    #
    def host
      @host ||= ENV["COUCHDB_HOST"] || "127.0.0.1"
    end

    # Returns CouchDB port
    #
    # @return [Fixnum]
    #
    def port
      @port ||= ENV["COUCHDB_PORT"] || "5984"
    end

    # Returns CouchDB url
    # (based on 'host' and 'port' attributes)
    #
    # @return [String]
    #
    def url
      "#{host}:#{port}"
    end

    # Returns CouchORM logger
    #
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # @private
    #
    def inspect
      "#<CouchORM connected to #{url}>"
    end

    alias_method :to_s, :inspect
    alias_method :to_str, :inspect

    # Main configuration method
    #
    # @yield config
    # @return config
    #
    def setup
      yield self
      self
    end

    # Resets configuration to default
    #
    def reset_configuration!
      @host = nil
      @port = nil
    end

  end
end