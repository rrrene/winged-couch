require 'json/ext'

module WingedCouch

  # Module for sending requests to CouchDB
  #
  module HTTP
    class << self

      attr_accessor :host

      def host
        @host ||= WingedCouch.url
      end

      # Send +GET+ request to specified url
      #
      # @param url [String]
      #
      # @return response
      #
      # @yield response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.get("http://my-couchdb-server.com")
      #   # => { "couchdb" => "Welcome", "version" => "1.0.1" }
      #
      #   WingedCouch::HTTP.get("http://my-couchdb-server.com") do |response|
      #     puts response
      #   end
      #   # => same output
      #
      def get(url, &block)
        perform(:get, url, { content_type: :json }, &block)
      end

      # Send +POST+ request to specified url
      #
      # @param url [String]
      # @param body [String]
      #
      # @return response
      # @yield response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.post("http://my-couchdb-server.com/db_name", { "asd" => "qwe" })
      #   # => { "ok" => true, "id" => "some-long-id", "rev" => "revision" }
      #
      #   WingedCouch::HTTP.post("http://my-couchdb-server.com/db_name", { "asd" => "qwe" }) do |response|
      #     puts response
      #   end
      #   # => same output
      #
      def post(url, body = "", &block)
        perform(:post, url, body, { content_type: :json }, &block)
      end

      # Send +PUT+ request to specified url
      #
      # @param url [String]
      # @param body [String]
      #
      # @return response
      # @yield response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.put("http://my-couchdb-server.com/db_name")
      #   # => { "ok" => true }
      #
      #   WingedCouch::HTTP.put("http://my-couchdb-server.com/db_name") do |response|
      #     puts response
      #   end
      #   # => same output
      #
      def put(url, body = "", &block)
        perform(:put, url, body, { content_type: :json }, &block)
      end

      # Send +DELETE+ request to specified url
      #
      # @param url [String]
      #
      # @return response
      # @yield response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.delete("http://my-couchdb-server.com/db_name")
      #   # => { "ok" => true }
      #
      #   WingedCouch::HTTP.delete("http://my-couchdb-server.com/db_name") do |response|
      #     puts response
      #   end
      #   # => same output
      #
      def delete(url, &block)
        perform(:delete, url, { content_type: :json }, &block)
      end

      private

      def perform(request_type, *args, &block)
        url = args.shift
        url = [host, url].join if host
        response = JSON.parse RestClient.send(request_type, url, *args)
        WingedCouch.logger.info "#{request_type.upcase} #{url} #{args.inspect}" if WingedCouch.logger
        block.call(response) if block
        response
      end
    end

  end
end