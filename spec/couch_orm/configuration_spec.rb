require 'spec_helper'

describe CouchORM::Configuration do

  let(:default_host) { ENV["COUCHDB_HOST"] || "127.0.0.1" }
  let(:default_port) { ENV["COUCHDB_PORT"] || "5984" }

  let(:configured_host) { double(:ConfiguredHost) }
  let(:configured_port) { double(:ConfiguredPort) }

  after(:each) { CouchORM.reset_configuration! }

  context "#reset_configuration!" do
    it "should reset host" do
      CouchORM.host = configured_host
      CouchORM.reset_configuration!
      CouchORM.host.should eq default_host
    end

    it "should reset port" do
      CouchORM.port = "port"
      CouchORM.reset_configuration!
      CouchORM.port.should eq default_port
    end
  end

  context "without configuration" do

    before { CouchORM.reset_configuration! }

    it "#host" do
      CouchORM.host.should eq default_host
    end

    it "#port" do
      CouchORM.port.should eq default_port
    end
  end

  context "with configuration" do

    before do
      CouchORM.setup do |config|
        config.host = configured_host
        config.port = configured_port
      end
    end

    it "#host" do
      CouchORM.host.should eq configured_host
    end

    it "#port" do
      CouchORM.port.should eq configured_port
    end
  end

  it "#url" do
    CouchORM.host = "host"
    CouchORM.port = "port"
    CouchORM.url.should eq "host:port"
  end

  it "#inspect" do
    CouchORM.stub(:url => "url")
    CouchORM.inspect.should eq "#<CouchORM connected to url>"
  end

  it ".logger" do
    CouchORM.logger.should be_a Logger
  end
end