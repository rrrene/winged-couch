require 'tempfile'
require 'json'

module Helpers
  module Models

    def model(model_name = :TestModel, &block)
      let(:database) { @model.database }

      around(:each) do |example|
        anonymous_model = Class.new(WingedCouch::Model, &block)
        @model = Object.const_set(model_name, anonymous_model)
        database.create rescue nil
        example.run
        database.drop
        Object.send(:remove_const, model_name)
      end

    end

    def views(hash)

      before(:each) do
        raise "Please, call `model` before `views`" unless @model

        @file = Tempfile.new("views")

        @file.write "var #{@model.name}Views = #{hash.to_json};"
        @file.close

        WingedCouch::ViewsLoader.filepath = @file.path
        WingedCouch::ViewsLoader.upload_views_for(@model)
      end

      after(:each) do
        @file.unlink
      end

    end

  end
end