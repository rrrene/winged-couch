require 'active_support/concern'

module Helpers
  module UploadViews
    extend ActiveSupport::Concern

    included do

      def self.asd
        binding.pry
      end

    end
  end
end