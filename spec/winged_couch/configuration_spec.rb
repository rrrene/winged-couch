require 'spec_helper'

describe WingedCouch::Configuration do

  let(:default_host) { ENV["COUCHDB_HOST"] || "127.0.0.1" }
  let(:default_port) { ENV["COUCHDB_PORT"] || "5984" }

  let(:configured_host) { double(:ConfiguredHost) }
  let(:configured_port) { double(:ConfiguredPort) }

  after(:each) { WingedCouch.reset_configuration! }

  context "#reset_configuration!" do
    it "should reset host" do
      WingedCouch.host = configured_host
      WingedCouch.reset_configuration!
      WingedCouch.host.should eq default_host
    end

    it "should reset port" do
      WingedCouch.port = "port"
      WingedCouch.reset_configuration!
      WingedCouch.port.should eq default_port
    end
  end

  context "without configuration" do

    before { WingedCouch.reset_configuration! }

    it "#host" do
      WingedCouch.host.should eq default_host
    end

    it "#port" do
      WingedCouch.port.should eq default_port
    end
  end

  context "with configuration" do

    before do
      WingedCouch.setup do |config|
        config.host = configured_host
        config.port = configured_port
      end
    end

    it "#host" do
      WingedCouch.host.should eq configured_host
    end

    it "#port" do
      WingedCouch.port.should eq configured_port
    end
  end

  it "#url" do
    WingedCouch.host = "host"
    WingedCouch.port = "port"
    WingedCouch.url.should eq "host:port"
  end

  it "#inspect" do
    WingedCouch.stub(:url => "url")
    WingedCouch.inspect.should eq "#<WingedCouch connected to url>"
  end
end