require 'v8' unless defined?(V8)

module WingedCouch

  # Class for fetching and uploading views to CouchDB
  #
  class ViewsLoader

    class << self

      attr_accessor :filepath

      # @private
      STRINGIFY_JS = File.read(File.join(WingedCouch::JAVASCRIPTS_PATH, "stringify_object.js"))

      # Returns hash with all defined views for specified class
      #
      # @param klass [Class] WingedCouch model
      #
      # @return [Hash] in format { "view name" => { "map" => "function() { some(javascript); }" } }
      #
      def fetch(klass)
        js_klass = "#{klass.name}Views"
        sourcecode = File.read(filepath)
        context = V8::Context.new do |v8|
          v8.eval(sourcecode)
          v8.eval(STRINGIFY_JS)
        end
        json = context.eval("JSON.stringify(stringifyObject(#{js_klass}))")
        JSON.parse(json)
      end

      # Uploads views for specified class to CouchDB
      #
      # @param klass [Class] WingedCouch::Model
      #
      # @return nil
      #
      def upload_views_for(klass)
        current_revision = klass.database.get("/_design/winged_couch")["_rev"] rescue nil
        data = {
          _id: "_design/winged_couch",
          views: fetch(klass)
        }
        data.merge!(_rev: current_revision) if current_revision
        klass.database.put("/_design/winged_couch", data.to_json)
      end

    end

  end
end