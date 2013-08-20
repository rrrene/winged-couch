module CouchORM
  module Models

    # Module with sytax sugar methods
    #
    module API

      def self.included(klass)
        klass.extend(ClassMethods)
      end

      # Class methods (syntax sugar)
      #
      module ClassMethods

        # Creates record and returns it
        #
        # @param attrs [Hash] hash of attributes
        #
        # @return [CouchORM::Model]
        #
        def create(attrs = {})
          self.new(attrs).tap(&:save)
        end

        # Returns design views in current database
        #
        def views
          database.design_views.keys
        end

      end

      # Constructor
      #
      # @param attrs [Hash] hash of attributes
      #
      def initialize(attrs = {})
        attrs.each do |attribute, value|
          if attribute.to_s == "id"
            send("_id=", value)
          elsif attribute.to_s == "rev"
            send("_rev=", value)
          else
            send("#{attribute}=", value)
          end
        end
      end

      # @private
      def inspect
        "#<#{self.class.name} " + attributes.merge(_id: _id, _rev: _rev).map { |k, v| "#{k}: #{v.inspect}" }.join(", ") + ">"
      end

      alias_method :to_s,   :inspect
      alias_method :to_str, :inspect

    end
  end
end