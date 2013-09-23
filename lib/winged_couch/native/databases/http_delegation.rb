module WingedCouch
  module Native
    module Databases

      # Module with methods for delegation requests to +WingedCouch::HTTP+
      #
      # @see WingedCouch::HTTP
      module HTTPDelegation

        # Performs get request to database
        # (simply delegates to WingedCouch::HTTP with `database name` prefix)
        #
        def get(url)
          HTTP.get("/#{name}#{url}")
        end

        # Performs post request to database
        # (simply delegates to WingedCouch::HTTP with `database name` prefix)
        #
        def post(url, data)
          HTTP.post("/#{name}#{url}", data)
        end

        # Performs put request to database
        # (simply delegates to WingedCouch::HTTP with `database name` prefix)
        #
        def put(url, data)
          HTTP.put("/#{name}#{url}", data)
        end

        # Performs delete request to database
        # (simply delegates to WingedCouch::HTTP with `database name` prefix)
        #
        def delete(url)
          HTTP.delete("/#{name}#{url}")
        end

      end
    end
  end
end