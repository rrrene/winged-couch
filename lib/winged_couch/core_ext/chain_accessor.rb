module WingedCouch

  # @see ChainAccessor
  module CoreExt

    # @see #chain_accessor
    module ChainAccessor

      # Method for defining `chain` accessors
      #
      # @example
      #   class MyClass
      #     chain_accessor :key1
      #     chain_accessor :key2, default: 123
      #     chain_accessor :params, as: :hash
      #     chain_accessor :options, as: :hash, chain_name: :option
      #   end
      #
      #   i = MyClass.new
      #
      #   i.with_key1("a")
      #   # => #<MyClass:instance key1="a" ...>
      #   i.key1
      #   # => "a"
      #
      #   i.key2
      #   # => 123
      #
      #   i.with_key2("key2).key2
      #   # => "key2"
      #
      #   i.with_params("key", "value")
      #   i.params
      #   # => { "key" => "value" }
      #
      #   i.with_option("key", "value")
      #   # because "chain_value" was passed as "option"
      #   i.options # but options for accessor
      #   # => { "key" => "value" }
      #
      def chain_accessor(attr_name, options = {})

        attr_accessor attr_name

        if options[:as] == :hash
          define_hash_chash_accessor(attr_name, options)
        else
          define_key_value_chain_accesor(attr_name, options)
        end

      end

      private

      def define_hash_chash_accessor(attr_name, options)
        define_method attr_name do
          hash = instance_variable_get("@#{attr_name}")
          hash = instance_variable_set("@#{attr_name}", {}) unless hash
          hash
        end

        define_method "with_#{options[:chain_name] || attr_name}" do |key, value|
          send(attr_name)[key] = value
          self
        end
      end

      def define_key_value_chain_accesor(attr_name, options)
        if default = options[:default]
          define_method attr_name do
            if value = instance_variable_get("@#{attr_name}")
              value
            else
              instance_variable_set("@#{attr_name}", default)
            end
          end
        end

        define_method "with_#{attr_name}" do |value|
          send("#{attr_name}=", value)
          self
        end
      end

    end
  end
end

Object.extend(WingedCouch::CoreExt::ChainAccessor)