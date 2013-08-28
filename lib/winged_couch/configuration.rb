require 'logger'

module WingedCouch

  # Main configuration module
  #
  # @example Usage:
  #   WingedCouch.setup do |config|
  #     config.host = "couch-db-host.com"
  #     config.port = 1234
  #   end
  #
  #   WingedCouch.host
  #   # => "couch-db-host.com"
  #
  #   WingedCouch.port
  #   # => 1234
  #
  #   WingedCouch.reset_configuration!
  #   # => nil
  #
  #   WingedCouch.host
  #   # => "127.0.0.1"
  #
  #   WingedCouch.port
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

    # Returns WingedCouch logger
    #
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # @private
    #
    def inspect
      "#<WingedCouch connected to #{url}>"
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