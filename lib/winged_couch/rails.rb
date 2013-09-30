module WingedCouch
  module Rails
    module ViewHelpers

      def generate_couch_model(klass, client_model_name = nil)
        client_model_name ||= klass.name.demodulize
        javascript_tag do
          "WingedCouch.Model.build('#{client_model_name}', '#{klass.database.name}')".html_safe
        end
      end

    end
  end
end