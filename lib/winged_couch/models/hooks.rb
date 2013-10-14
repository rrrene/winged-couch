module WingedCouch
  module Models
    module Hooks

      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods

        def before(hook_action, method_name = nil, &block)
          hooks[:before][hook_action] << (method_name || block)
        end

        def after(hook_action, method_name = nil, &block)
          hooks[:after][hook_action] << (method_name || block)
        end

        private

        def hooks
          @hooks ||= Hash.new { |h1, k1| h1[k1] = Hash.new { |h2, k2| h2[k2] = Array.new } }
        end
      end

      private

      def run_hooks(hook_type, hook_action)
        self.class.send(:hooks)[hook_type][hook_action].each do |method_name_or_block|
          if method_name_or_block.respond_to?(:call)
            instance_eval(&method_name_or_block)
          else
            send(method_name_or_block)
          end
        end
      end

    end
  end
end