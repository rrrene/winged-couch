require 'active_support/concern'

module Helpers

  # Module for testing database
  #
  # Requires method 'database' (you can define it using 'let')
  #
  # @example
  #   let(:database) { WingedCouch::Native::Database.new("db-name") }
  #
  module WithDatabase

    extend ActiveSupport::Concern

    included do

      around(:each) do |example|
        raise "Please, define let(:database) { ... }" unless respond_to?(:database)
        begin
          database.create rescue nil
          example.run
        ensure
          database.drop
        end
      end

    end
  end
end