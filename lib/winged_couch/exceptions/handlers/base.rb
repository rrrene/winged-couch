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

        def database_level?
          http_path.level == :database
        end

        def document_level?
          http_path.level == :document
        end


      end
    end
  end
end
