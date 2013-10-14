module WingedCouch
  class HttpPath

    attr_accessor :host, :path

    def initialize(host = WingedCouch.url)
      @host = host
      @path = []
    end

    def join!(path)
      @path << without_slashes(path)
      self
    end

    def join(path)
      dup.join!(path)
    end

    def self.join(path)
      new.join(path)
    end

    def to_s
      args.join("/")
    end

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