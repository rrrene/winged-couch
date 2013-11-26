module WingedCouch
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
        # @return [WingedCouch::Model]
        #
        def create(attrs = {})
          self.new(attrs).tap(&:save)
        end

        # Finds record in CoucDB
        #
        # @param _id [String] id of record
        #
        # @return [WingedCouch::Model]
        #
        def find(_id)
          self.new(HTTP.get(database.path.join(_id)))
        end

        # Returns design views in the database
        #
        def views
          database.design_views.keys
        end

        def count
          database.info["doc_count"]
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
        run_hooks(:after, :initialize)
      end

      # @private
      def inspect
        "#<#{self.class.name} " + attributes.merge(_id: _id, _rev: _rev).map { |k, v| "#{k}: #{v.inspect}" }.join(", ") + ">"
      end

      # @private
      def ==(other)
        other.is_a?(self.class) && other._id == self._id
      end

      alias_method :to_s,   :inspect
      alias_method :to_str, :inspect

      def with!(data = {})
        data.each do |attr_name, attr_value|
          public_send("#{attr_name}=", attr_value)
        end
        self
      end

      def with(data = {})
        dup.with!(data)
      end

    end
  end
end