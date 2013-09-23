require 'v8' unless defined?(V8)

module WingedCouch

  # Class for fetching and uploading views to CouchDB
  #
  class ViewsLoader

    class << self

      attr_accessor :filepath

      # @private
      STRINGIFY_JS = File.read(File.join(JAVASCRIPTS_PATH, "stringify_object.js"))

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
      def upload_views_for(klass)
        database = klass.database
        database.create unless database.exist?

        design_document = Design::Document.new(database)
        design_document.save unless design_document.exist?

        fetch(klass).each do |view_name, functions|
          functions.each do |function_name, function_code|
            Design::View.create(design_document, view_name, function_name, function_code)
          end
        end
      end

    end

  end
end