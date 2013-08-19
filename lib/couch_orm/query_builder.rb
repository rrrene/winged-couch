module CouchORM

  # Class for building queries to CouchDB database
  #
  # @example
  #   builder = CouchORM::Builder.new
  #   builder.
  #    with_database(Profile.database).
  #    with_path("/_design/couch-orm/all").
  #    with_param("limit", 100).
  #    with_http_method("get").
  #    perform
  #   # => { "count" => 100, "records" => [...] }
  #
  class QueryBuilder

    # Returns same builder with stored +database+
    #
    # @param database [CouchORM::Database]
    #
    # @return [CouchORM::QueryBuilder]
    #
    def with_database(database)
      @database = database
      self
    end

    # Returns same builder with stored +path+
    #
    # @param path [String]
    #
    # @return [CouchORM::Builder]
    #
    def with_path(path)
      @path = path
      self
    end

    # Returns same builder with stored request params
    #  (+key+ => +value+)
    #
    # @param key [String, Symbol]
    # @param value [String, Symbol
    #
    # @return [CouchORM::QueryBuilder]
    #
    def with_param(key, value)
      params[key] = value
      self
    end

    # Returns same builder with store +http method+
    #
    # @param http_method [String] "get", "post", "put" or "delete"
    #
    # @return [CouchORM::QueryBulider]
    #
    def with_http_method(http_method)
      @http_method = http_method
      self
    end

    # Performs http request with specified parameters
    #
    # @return [Hash] response
    #
    # @see #with_database
    # @see #with_path
    # @see #with_param
    # @see #with_http_method
    #
    def perform
      validate
      database.send(http_method, *query)
    end

    private

    attr_reader :database, :path

    def http_method
      @http_method ||= "get"
    end

    def params
      @params ||= {}
    end


    def validate
      if [database, path, params, http_method].any?(&:nil?)
        raise RuntimeError
      end
    end

    def query
      if http_method == "get"
        url = params.empty? ? path : "#{path}?#{URI.encode_www_form(params)}"
        [url]
      else
        [path, params]
      end
    end
  end
end