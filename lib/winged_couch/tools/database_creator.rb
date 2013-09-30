module WingedCouch
  module Tools
    
    # Module for creating missing databases
    #
    module DatabaseCreator

      extend Base

      class << self

        # Creates missing databases
        #
        # @param logger [Logger]
        #
        def create_missing_databases(logger = Logger.new(STDOUT))
          each_model do |model|
            if model.database.exist?
              logger.info %Q{Database for model "#{model.name} aleady exist}
            else
              model.database.create
              logger.info %Q{Created database for model "#{model.name}"}
            end
          end
        end
      end

    end
  end
end