require 'winged_couch/exceptions/handler'

module WingedCouch

  # @private
  #
  module Exceptions

    class << self
      def build(&block)
        Class.new(StandardError).tap do |klass|
          class << klass
            attr_accessor :blk

            def raise(*args)
              message = blk.call(*args)
              Kernel.raise self, message
            end
          end
          klass.blk = block
        end
      end
    end

    # Database-specific exceptions
    #
    NoDatabase = build { |db_name| %Q{Database "#{db_name}" is missing} }
    DatabaseAlreadyExist = build { |db_name| %Q{Database "#{name}" already exist} }
    ReservedDatabase = build { |db_name| %Q{Database "#{db_name}" is internal, you can't remove it.} }
    NoDesignDocument = build { |db_name| %Q{Can't find design document in database "#{db_name}"} }

    # Document-specific exceptions
    #
    DocumentMissing = build { |message| message }

    # Model-specific exceptions
    #
    UnsupportedType = build { |klass1, klass2| "Unsupported class #{klass1} used for type-casting attribute in model #{klass2}" }

  end

end