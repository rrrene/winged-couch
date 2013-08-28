module WingedCouch
  module Models

    # Module for defining query-methods
    #
    module Views

      def self.included(klass)
        klass.extend(ClassMethods)
      end

      # Module with class-methods for defining query-methods
      module ClassMethods

        # Returns all defined (in current model) design views
        #
        # @return [Array<Hash>]
        #
        def _views
          @_views ||= []
        end

        # Method for defining view
        #
        # @param view_name [String] name of view
        # @param options [Hash]
        #
        def view(view_name, options = {})
          self._views << { name: view_name, options: options }
          define_view(view_name, options)
        end

        protected

        def define_view(view_name, options)
          singleton_class.send(:define_method, view_name) do
            WingedCouch::View.new(database, view_name).get["rows"].map do |row|
              self.new(row["key"])
            end
          end
        end

      end

    end
  end
end
