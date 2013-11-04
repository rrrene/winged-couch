require 'spec_helper'

describe WingedCouch::Configuration do

  let(:default_host) { ENV["COUCHDB_HOST"] || "127.0.0.1" }
  let(:default_port) { ENV["COUCHDB_PORT"] || "5984" }

  let(:configured_host) { double(:ConfiguredHost) }
  let(:configured_port) { double(:ConfiguredPort) }

  after(:each) { WingedCouch.reset_configuration! }

  subject(:config) { WingedCouch }

  context "#reset_configuration!" do

    before do
      WingedCouch.host = configured_host
      WingedCouch.port = configured_port
      WingedCouch.reset_configuration!
    end
    
    its(:host) { should eq default_host }
    its(:port) { should eq default_port }
  end

  context "without configuration" do
    before { WingedCouch.reset_configuration! }

    its(:host) { should eq default_host }
    its(:port) { should eq default_port }
  end

  context "with configuration" do
    before do
      WingedCouch.setup do |config|
        config.host = configured_host
        config.port = configured_port
      end
    end

    its(:host) { should eq configured_host }
    its(:port) { should eq configured_port }
  end

  context "#url" do
    before do
      WingedCouch.host = "host"
      WingedCouch.port = "port"
    end

    its(:url) { should eq("host:port") }
  end

  context "#inspect" do
    before { WingedCouch.stub(:url => "url") }
    let(:expected_url) { "#<WingedCouch connected to url>" }
    its(:inspect) { should eq(expected_url) }
  end
end