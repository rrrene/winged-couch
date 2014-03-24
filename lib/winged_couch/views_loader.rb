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
        js_klass = "#{klass.name.delete('::')}Views"
        begin
          json = v8_context.eval("JSON.stringify(stringifyObject(#{js_klass}))")
          JSON.parse(json)
        rescue => e
          raise Exceptions::ViewsMissing if e.message == "#{js_klass} is not defined"
          raise e
        end
      end

      # Uploads views for specified class to CouchDB
      #
      # @param klass [Class] WingedCouch::Model
      #
      def upload_views_for(klass)
        design_document = klass.design_document

        fetch(klass).each do |view_name, functions|
          functions.each do |function_name, function_code|
            Design::View.create(design_document, view_name, function_name, function_code)
          end
        end
      end

      private

      def v8_context
        V8::Context.new do |v8|
          v8.eval(File.read(filepath))
          v8.eval(STRINGIFY_JS)
        end
      end

      def reset_v8_context
        @context = nil
      end

    end

  end
end