module CouchORM

  # Class for working with CouchDB Views
  #
  # @example
  #   db = CouchORM::Database.create("my_db")
  #
  #   view = CouchORM::View.new(db, "my_view")
  #   view.exist?
  #   # => false
  #
  #   view = CouchORM::View.new(db, "predefined_view")
  #   view.exist?
  #   # => true
  #
  #   view.get
  #   # => { "total_rows" => 0, "rows" => [ .... ] }
  #
  #   view.source
  #   # => { "map" => "some javascript", "reduce" => "other js.." }
  #
  #   CouchORM::View.all(db)
  #   # => [#<CouchORM::View name="predefined_view", database="my_db"]
  #
  #   CouchORM::View.names(db)
  #   # => ["predefined_view"]
  #
  class View

    attr_accessor :database
    attr_accessor :name

    # Constructor
    #
    # @param database [CouchORM::Database]
    # @param name [String] name of view
    #
    def initialize(database, name)
      @database = database
      @name = name
    end

    # Returns true if view exist in database
    #
    def exist?
      self.database.design_views.has_key? self.name
    end

    # Returns result of view calculation
    #
    # @return [Hash]
    #
    def get
      database.get(view_path)
    end

    # Returns source code of view
    #
    # @return [Hash]
    #
    def source
      database.design_views[name]
    end

    # @private
    def ==(other)
      other.is_a?(CouchORM::View) && self.name == other.name && self.database == other.database
    end

    # @private
    def inspect
      "#<CouchORM::View name='#{self.name}', database='#{database.name}'>"
    end

    alias_method :to_s, :inspect
    alias_method :to_str, :inspect

    class << self

      # Returns all views in specified database
      #
      # @param database [CouchORM::Database]
      #
      # @return [Array<CouchORM::View>]
      #
      def all(database)
        if database.exist?
          database.design_views.map do |name,_|
            self.new(database, name)
          end
        else
          []
        end
      end

      # Returns names of views in specified database
      #
      # @param database [CouchORM::Database]
      #
      # @return [Array<String>]
      #
      def names(database)
        database.design_views.keys
      end

    end

    protected

    def view_path
      "/_design/couch_orm/_view/#{name}"
    end

  end
end