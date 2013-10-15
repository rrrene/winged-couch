module WingedCouch

  # Class for storing URL path
  #
  class HttpPath

    attr_accessor :host, :path

    def initialize(host = WingedCouch.url)
      @host = without_slashes(host.to_s)
      @path = []
    end

    # Joins current path with passed
    #
    # @param path [String, Symbol]
    #
    # @return [WingedCouch::HttpPath] self
    #
    def join!(path)
      @path << without_slashes(path.to_s)
      self
    end

    # Returns new HttpPath instance with joined path
    #
    # @param path [String, Symbol]
    #
    # @return [WingedCouch::HttpPath] new path
    #
    def join(path)
      dup.join!(path)
    end

    # Returns new HttpPath instance with joined path
    #
    # @param path [String, Symbol]
    #
    # @return path
    def self.join(path)
      new.join(path)
    end

    # Returns string representation of http path
    #
    # @return [String]
    #
    def to_s
      args.join("/")
    end

    # @private
    def ==(other)
      other.is_a?(self.class) && host == other.host && path == other.path
    end

    private

    def args
      [host] + path
    end

    def without_slashes(path)
      path.gsub(/^\//, "").gsub(/\/$/, "")
    end

  end
end