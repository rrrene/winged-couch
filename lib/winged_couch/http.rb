require 'json/ext'

module WingedCouch

  # Module for sending requests to CouchDB
  #
  module HTTP
    class << self

      attr_accessor :host

      def path
        HttpPath.new
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
      def get(http_path, params = {})
        perform(:get, http_path, { params: params, content_type: :json })
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
      def post(http_path, body = {})
        perform(:post, http_path, body.to_json, { content_type: :json })
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
      def put(http_path, body = {})
        perform(:put, http_path, body.to_json, { content_type: :json })
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
      def delete(http_path, params = {})
        perform(:delete, http_path, { params: params, content_type: :json })
      end

      private

      def perform(request_type, *args)
        url = args.shift.to_s
        response = fetch(request_type, url, args)
        response
      end

      def fetch(request_type, url, args)
        start = Time.now
        response = JSON.parse RestClient.send(request_type, url, *args)
        WingedCouch.logger.info "\e[0;32m#{request_type.upcase} #{url} (#{Time.now - start}) \e[0;0m" if WingedCouch.logger
        response
      end
    end

  end
end