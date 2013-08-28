module WingedCouch
  # @private
  NoDatabase           = Class.new(StandardError)
  # @private
  DatabaseAlreadyExist = Class.new(StandardError)
  # @private
  ReservedDatabase     = Class.new(StandardError)
  # @private
  NoDesignDocument     = Class.new(StandardError)
end