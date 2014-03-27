require 'winged_couch/models/attributes'
require 'winged_couch/models/persistence'
require 'winged_couch/models/api'
require 'winged_couch/models/queries'
require 'winged_couch/models/validation'
require 'winged_couch/models/hooks'
require 'winged_couch/models/bulk'

module WingedCouch

  # Main model class
  #
  class Model
    include ::WingedCouch::Models::Attributes
    include ::WingedCouch::Models::Persistence
    include ::WingedCouch::Models::API
    extend  ::WingedCouch::Models::Queries
    include ::WingedCouch::Models::Validation
    include ::WingedCouch::Models::Hooks
    extend  ::WingedCouch::Models::Bulk

    def self.inherited(klass)
      super
      ViewsLoader.upload_views_for(klass)
    end

    if defined?(ActiveModel) # Rails support
      extend  ActiveModel::Naming
      extend  ActiveModel::Translation
      include ActiveModel::Validations
      include ActiveModel::Conversion

      # @private
      def to_key
        [_id]
      end
    end
  end

end