require 'active_support/concern'

module Helpers
  module FlushDBs
    extend ActiveSupport::Concern

    included do

      around(:each) do |example|
        begin
          WingedCouch::Native::Database.reset_all
          WingedCouch::Native::Database.each { |db| db.drop rescue nil }
          example.run
        ensure
          WingedCouch::Native::Database.reset_all
          WingedCouch::Native::Database.each { |db| db.drop rescue nil }
        end
      end

    end
  end
end