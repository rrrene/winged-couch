module WingedCouch
  module Native

    # Class for working with CouchDB Views
    #
    # @example
    #   db = WingedCouch::Database.create("my_db")
    #
    #   view = WingedCouch::View.new(db, "my_view")
    #   view.exist?
    #   # => false
    #
    #   view = WingedCouch::View.new(db, "predefined_view")
    #   view.exist?
    #   # => true
    #
    #   view.get
    #   # => { "total_rows" => 0, "rows" => [ .... ] }
    #
    #   view.source
    #   # => { "map" => "some javascript", "reduce" => "other js.." }
    #
    #   WingedCouch::View.all(db)
    #   # => [#<WingedCouch::View name="predefined_view", database="my_db"]
    #
    #   WingedCouch::View.names(db)
    #   # => ["predefined_view"]
    #
    class View

      attr_accessor :database
      attr_accessor :name

      # Constructor
      #
      # @param database [WingedCouch::Database]
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
        other.is_a?(self.class) && self.name == other.name && self.database == other.database
      end

      # @private
      def inspect
        "#<WingedCouch::View name='#{self.name}', database='#{database.name}'>"
      end

      alias_method :to_s, :inspect
      alias_method :to_str, :inspect

      # @private
      def strategy
        case source.keys
        when ["map"]           then "view:map"
        when ["map", "reduce"] then "view:map:reduce"
        else "unknown"
        end
      end

      class << self

        # Returns all views in specified database
        #
        # @param database [WingedCouch::Database]
        #
        # @return [Array<WingedCouch::View>]
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
        # @param database [WingedCouch::Database]
        #
        # @return [Array<String>]
        #
        def names(database)
          database.design_views.keys
        end

      end

      protected

      def view_path
        "/_design/winged_couch/_view/#{name}"
      end

    end

  end
end