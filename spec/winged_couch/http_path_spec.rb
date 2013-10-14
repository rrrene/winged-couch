require 'spec_helper'

module WingedCouch
  describe HttpPath do
    let(:host) { "host" }

    let(:http_path) { HttpPath.new }

    describe "#initialize" do
      it "stores url" do
        http_path.host.should eq(WingedCouch.url)
      end

      it "makes path blank" do
        http_path.path.should eq([])
      end
    end

    describe "#join" do
      it "stores passed path" do
        http_path.join("path").path.should eq(["path"])
      end
    end

    describe ".join" do
      it "returns new instance with passed path" do
        HttpPath.join("path").path.should eq(["path"])
      end
    end

    describe "#without_slashes" do
      it "removes slashes from the beginning of passed path" do
        HttpPath.join("/path").path.should eq(["path"])
      end

      it "removed slashes from the end  of the passed path" do
        HttpPath.join("path/").path.should eq(["path"])
      end

      it "doesn't remove slashes in the middle of the passed path" do
        HttpPath.join("/path/to/").path.should eq(["path/to"])
      end
    end

  end
end