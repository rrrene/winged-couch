module WingedCouch

  # Module with mixins for WingedCouch::Model class
  #
  module Models

    # Module for defining model attributes
    #
    module Attributes

      def self.included(klass)
        klass.extend ClassMethods
      end

      # Module with class-methods for atributes defining
      #
      module ClassMethods

        # @private
        #
        def inherited(klass)
          klass._attributes += _attributes
          super
        end

        # Returns attribute names
        #
        # @return [Array]
        #
        def attribute_names
          _attributes.map(&:first)
        end

        # Method for defining attribute
        #
        # @param attr_name [Symbol] name of attribute
        # @param attr_klass [Class] class for type-casting
        # @param options [Hash]
        # @option options [Object] :default default value of attribute
        #
        def attribute(attr_name, attr_klass, options = {})
          self._attributes << [attr_name, attr_klass, options]
          define_attribute(attr_name, attr_klass, options)
        end

        protected

        def _attributes
          @_attributes ||= []
        end

        attr_writer :_attributes

        def define_attribute(attr_name, attr_klass, options)
          define_method attr_name do
            native_document.data[attr_name] || options[:default]
          end

          define_method "#{attr_name}=" do |value|
            native_document.data[attr_name] = type_cast_to_instance_of_klass(value, attr_klass)
          end
        end

      end

      def native_document
        @native_document ||= Native::Document.new(self.class.database)
      end

      # Returns hash of attributes in format { key: value }
      #
      # @return [Hash]
      #
      def attributes
        Hash[self.class.attribute_names.map { |attr_name| [attr_name, send(attr_name)] }]
      end

      private

      def type_cast_to_instance_of_klass(value, klass)
        if klass == String
          value.to_s
        elsif klass == Fixnum or klass == Bignum
          value.to_i
        elsif klass == Symbol
          value.to_sym
        else
          raise Exceptions::UnsupportedType, "Unsupported class #{klass} used for type-casting attribute in model #{self.class.name}"
        end
      end

    end
  end

end