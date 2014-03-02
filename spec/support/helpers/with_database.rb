require 'active_support/concern'

module Helpers
  module WithDatabase

    extend ActiveSupport::Concern

    included do

      around(:each) do |example|
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