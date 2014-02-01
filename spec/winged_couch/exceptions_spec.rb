require 'spec_helper'

module WingedCouch
  describe Exceptions do
    TestException = Exceptions.build { |message| "TestException: #{message}" }

    it "allows to define custom exceptions" do
      expect { TestException.raise("custom message") }.to raise_error(TestException, "TestException: custom message")
    end
  end
end