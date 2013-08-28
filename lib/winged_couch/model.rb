require 'winged_couch/models/attributes'
require 'winged_couch/models/persistence'
require 'winged_couch/models/api'
require 'winged_couch/models/queries'

module WingedCouch

  # Main model class
  #
  class Model
    include ::WingedCouch::Models::Attributes
    include ::WingedCouch::Models::Persistence
    include ::WingedCouch::Models::API
    extend  ::WingedCouch::Models::Queries
  end

end