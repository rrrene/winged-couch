module WingedCouch
  module Rails
    module ViewHelpers

      # Class with view helpers
      #
      class ClientSide

        # Trasnforms query to CouchDB database to client-side query
        #   Allows you to generate queries on server, but perform on client-side
        #
        # @param builder [WingedCouch::Queries::QueryBuilder]
        #
        # @return [String]
        #
        # @example
        #   # In your controller:
        #   @profiles = Profile.build(view: "by_name").limit(10).skip(20)
        #
        #   # In your view
        #   var profilesQuery = <%= winged_couch.client_side(@profiles) %>
        #   # => var profilesView = (new WingedCouch.View(Profile, 'by_name')).withParam('limit', '10').withParam('skip', '10');
        #
        def client_side(builder)
          view_name = builder.path.split("/").last
          model_name = builder.model.name
          result = "(new WingedCouch.View(#{model_name}, '#{view_name}'))"
          builder.params.each do |key, value|
            result += ".withParam('#{key}', '#{value}')"
          end
          result.html_safe
        end

        # Generates javascript class for specified server-side model
        #
        # @param klass [Class]
        # @param client_model_name [String] (demodulized name of `klass`)
        #
        # @return [String] javascript code
        #
        # @example
        #   # In your view:
        #   <%= winged_couch.generate_model Profile %>
        #   # => "WingedCouch.Model.build('Profile', 'profile');"
        #   # Now you can use class `Profile` in javascript
        #
        #   # You can specify name of client-side model:
        #   <%= winged_couch.generate_model Profile, 'MyModel' %>
        #   # => "WingedCouch.Model.build('MyModel', 'profile');"
        #   # => In this case, you javascript class is `MyModel`
        #
        def generate_model(klass, client_model_name = klass.name.demodulize)
          "WingedCouch.Model.build('#{client_model_name}', '#{klass.database.name}');".html_safe
        end
      end

      # Returns instance of WingedCouch client-side helper
      #
      # @return [WingedCouch::Rails::ViewHelpers::ClientSide]
      #
      def winged_couch
        @winged_couch ||= ClientSide.new
      end

    end
  end
end