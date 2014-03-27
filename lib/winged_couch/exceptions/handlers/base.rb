module WingedCouch
  module Exceptions
    module Handlers
      class Base < Struct.new(:request_type, :http_path, :args, :exception)

        def db_name
          http_path.path.first
        end

        def document_name
          http_path.path[1]
        end

        def response
          JSON.parse(exception.response) rescue {}
        end

        def reason
          response["reason"]
        end

        def error
          response["error"]
        end

        def not_found?
          exception.is_a?(RestClient::ResourceNotFound)
        end

        def precondition_failed?
          exception.is_a?(RestClient::PreconditionFailed)
        end

        def forbidden?
          exception.is_a?(RestClient::Forbidden)
        end

        [:database, :document, :design_document].each do |http_path_level|
          define_method "#{http_path_level}_level?" do
            http_path.level == http_path_level
          end
        end

        class << self
          def respond?(&block)
            define_method(:respond?, &block)
          end

          def call(&block)
            define_method(:call, &block)
          end
        end

      end
    end
  end
end
