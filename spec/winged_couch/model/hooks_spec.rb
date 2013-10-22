require 'spec_helper'

module WingedCouch
  module Models
    describe Hooks, :with_database do

      class ModelWithHooks < WingedCouch::Model
        attribute :name, String

        def data
          @data ||= []
        end

        def flush
          @data = []
        end
      end

      class ModelWithSaveHooks < ModelWithHooks
        before(:save) { data << :block_before_save }
        after(:save)  { data << :block_after_save  }

        before :save, :set_method_before_save
        after :save,  :set_method_after_save

        def set_method_before_save
          data << :method_before_save
        end

        def set_method_after_save
          data << :method_after_save
        end
      end

      class ModelWithUpdateHooks < ModelWithHooks
        before(:update) { data << :block_before_update }
        after(:update)  { data << :block_after_update  }

        before :update, :set_method_before_update
        after :update,  :set_method_after_update

        def set_method_before_update
          data << :method_before_update
        end

        def set_method_after_update
          data << :method_after_update
        end
      end

      class ModelWithDeleteHooks < ModelWithHooks
        before(:delete) { data << :block_before_delete }
        after(:delete)  { data << :block_after_delete  }

        before :delete, :set_method_before_delete
        after :delete,  :set_method_after_delete

        def set_method_before_delete
          data << :method_before_delete
        end

        def set_method_after_delete
          data << :method_after_delete
        end
      end

      {
        save: {
          model: ModelWithSaveHooks,
          action: proc { |record| nil }
        },
        update: {
          model: ModelWithUpdateHooks,
          action: proc { |record| record.update(name: "Name2") }
        },
        delete: {
          model: ModelWithDeleteHooks,
          action: proc { |record| record.delete }
        }
      }.each do |hook_type, hook_data|
        context "#{hook_type} hooks" do
          let(:model) { hook_data[:model] }
          let(:database) { model.database }
          let(:record) { model.create(name: "Name") }

          before { hook_data[:action].call(record) }

          context "before hooks" do
            it "runs block hooks" do
              record.data.should include(:"block_before_#{hook_type}")
            end

            it "runs method hookd" do
              record.data.should include(:"method_before_#{hook_type}")
            end
          end

          context "after hooks" do
            it "runs block hooks" do
              record.data.should include(:"block_after_#{hook_type}")
            end

            it "runs method hookd" do
              record.data.should include(:"method_after_#{hook_type}")
            end
          end

          context "order of running hooks" do

            let(:index) do
              {
                block_before: record.data.index(:"block_before_#{hook_type}"),
                method_before: record.data.index(:"method_before_#{hook_type}"),
                block_after: record.data.index(:"block_after_#{hook_type}"),
                method_after: record.data.index(:"method_after_#{hook_type}")
              }
            end

            it "runs all hooks in correct order" do
              index[:block_before].should < index[:block_after]
              index[:block_before].should < index[:method_after]

              index[:method_before].should < index[:block_after]
              index[:method_before].should < index[:method_after]
            end
          end
        end
      end

      context "after initialize hook" do
        class ModelWithInitializeHooks < ModelWithHooks
          after(:initialize) { data << :block_initialize }
          after :initialize, :after_initialize_method

          def after_initialize_method
            data << :method_initialize
          end
        end

        let(:database) { ModelWithInitializeHooks.database }
        let(:record) { ModelWithInitializeHooks.new(name: "Name") }

        it "runs block hooks" do
          record.data.should include(:block_initialize)
        end

        it "runs method hooks" do
          record.data.should include(:method_initialize)
        end
      end

    end
  end
end