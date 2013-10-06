module WingedCouch
  module Tools

    # @private
    module Base

      extend self

      def preload_models
        raise %Q{Directory "#{models_dir}" doesn't exist!} unless Dir.exists?(models_dir)
        pattern = File.join(models_dir, "**", "*.rb")
        Dir[pattern].each { |f| require f }
      end

      def each_model(options = {}, &block)
        WingedCouch::Model.subclasses.each do |klass|
          if options[:raise_exceptions] and not klass.database.exist?
            raise %Q{Database for model #{klass.name} doesn't exist, run rake winged_couch:db:create}
          end
          block.call(klass)
        end
      end

      private

      def models_dir
        @models_dir ||= begin
          dir = ENV["COUCH_MODELS_DIR"] || ::Rails.root.join("app", "models")
          dir.to_s.strip
        end
      end

    end
  end
end