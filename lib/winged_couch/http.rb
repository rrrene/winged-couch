require 'json/ext'

module WingedCouch

  # Module for sending requests to CouchDB
  #
  module HTTP
    class << self

      attr_accessor :host

      # Returns default blank http path
      #   (with url to the CouchDB server)
      #
      # @return [WingedCouch::HttpPath]
      #
      def path
        HttpPath.new
      end

      # Performs +GET+ request
      #
      # @param http_path [WingedCouch::HttpPath]
      # @param params [Hash]
      #
      # @return response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.get(path, { key: "value" })
      #
      def get(http_path, params = {})
        perform(:get, http_path, { params: params, content_type: :json })
      end

      # Performs +POST+ request
      #
      # @param http_path [WingedCouch::HttpPath]
      # @param body [Hash]
      #
      # @return response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.post(path, { key: "value" })
      #
      def post(http_path, body = {})
        perform(:post, http_path, body.to_json, { content_type: :json })
      end

      # Performs +PUT+ request
      #
      # @param http_path [WingedCouch::HttpPath]
      # @param body [Hash]
      #
      # @return response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.put(path, { key: "value" })
      #
      def put(http_path, body = {})
        perform(:put, http_path, body.to_json, { content_type: :json })
      end

      # Performs +DELETE+ request
      #
      # @param http_path [WingedCouch::HttpPath]
      # @param params [Hash]
      #
      # @return response
      #
      # @example Usage:
      #   response = WingedCouch::HTTP.delete(path, { key: "value" })
      #
      def delete(http_path, params = {})
        perform(:delete, http_path, { params: params, content_type: :json })
      end

      # Performe +HEAD+ request
      #
      # @param http_path [WingedCouch::HttpPath]
      #
      # @return response
      #
      def head(http_path)
        perform(:head, http_path)
      end

      private

      def perform(request_type, *args)
        url = args.shift.to_s
        response = fetch(request_type, url, args)
        response
      end

      def fetch(request_type, url, args)
        start = Time.now
        raw_response = RestClient.send(request_type, url, *args)
        response = request_type == :head ? raw_response : JSON.parse(raw_response)
        WingedCouch.logger.info "\e[0;32m#{request_type.upcase} #{url} (#{Time.now - start}) \e[0;0m" if WingedCouch.logger
        response
      end
    end

  end
end