module WingedCouch
  module Exceptions
    def self.const_missing(const_name)
      const_set const_name, Class.new(StandardError)
    end
  end
end