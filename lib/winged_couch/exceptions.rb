require 'winged_couch/exceptions/handler'

module WingedCouch

  # @private
  #
  module Exceptions

    class << self
      def error(&block)
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
    NoDatabase = error { |db_name| %Q{Database "#{db_name}" is missing} }
    DatabaseAlreadyExist = error { |db_name| %Q{Database "#{name}" already exist} }
    ReservedDatabase = error { |db_name| %Q{Database "#{db_name}" is internal, you can't remove it.} }

    # Document-specific exceptions
    #
    DocumentMissing = error { |message| message }
    InvalidDocument = error { |message| message }

    # DesignDocument-specific exceptions
    NoDesignDocument = error { |db_name| %Q{Can't find design document in database "#{db_name}"} }

    # Model-specific exceptions
    #
    UnsupportedType = error { |klass1, klass2| "Unsupported class #{klass1} used for type-casting attribute in model #{klass2}" }

    # View-specific exceptions
    UnknownView = error { |view_name| %Q{Unknown view "#{view_name}"} }

  end

end