module WingedCouch

  # Class for storing URL path
  #
  class HttpPath

    attr_accessor :host, :path, :level

    def initialize(host = WingedCouch.url)
      @host = without_slashes(host.to_s)
      @path = []
      @level = :server
    end

    # Joins current path with passed
    #
    # @param path [String, Symbol]
    #
    # @return [WingedCouch::HttpPath] self
    #
    def join!(path, level = :server)
      @path << without_slashes(path.to_s)
      @level = level
      self
    end

    # Returns new HttpPath instance with joined path
    #
    # @param path [String, Symbol]
    #
    # @return [WingedCouch::HttpPath] new path
    #
    def join(path, level = :server)
      dup.join!(path, level)
    end

    # Returns new HttpPath instance with joined path
    #
    # @param path [String, Symbol]
    #
    # @return path
    def self.join(path, level = :server)
      new.join(path, level)
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