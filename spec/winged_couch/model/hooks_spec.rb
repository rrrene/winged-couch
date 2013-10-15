require 'spec_helper'

module WingedCouch
  module Models
    describe Hooks, :with_database do

      class ModelWithHooks < WingedCouch::Model
        attribute :name, String

        def temp_data
          @temp_data ||= []
        end

        def flush
          @temp_data = []
        end

        before :save do
          temp_data << :block_before_save
        end

        after :save do
          temp_data << :block_after_save
        end

        before :save, :set_method_before_save
        after  :save, :set_method_after_save

        def set_method_before_save
          temp_data << :method_before_save
        end

        def set_method_after_save
          temp_data << :method_after_save
        end

        def before_update
          temp_data << :before_update
        end

        before :update, :before_update

        def after_update
          temp_data << :after_update
        end

        after :update, :after_update

        def before_delete
          temp_data << :before_delete
        end

        before :delete, :before_delete

        def after_delete
          temp_data << :after_delete
        end

        after :delete, :after_delete
      end

      let(:database) { ModelWithHooks.database }

      let(:instance) { ModelWithHooks.create(name: "Name") }
      let(:data) { instance.temp_data }

      context "block hooks" do
        it "runs before hooks" do
          data.should include(:block_before_save)
        end

        it "runs after hooks" do
          data.should include(:block_after_save)
        end
      end

      context "method hooks" do
        it "runs before hooks" do
          data.should include(:method_before_save)
        end

        it "runs after hooks" do
          data.should include(:method_before_save)
        end
      end

      it "runs hooks in correct order" do
        data.index(:method_before_save).should < data.index(:method_after_save)
        data.index(:block_before_save).should < data.index(:block_after_save)
      end

      context "before/after update hooks" do
        before { instance.flush }

        it "runs before and after update hooks" do
          instance.update(name: "Name2")
          data.should eq([:before_update, :after_update])
        end

        it "doesn't run after update hooks if record wasn't updated" do
          instance._id = "non-existing-id"
          instance.update(name: "Name2") rescue nil
          data.should eq([:before_update])
        end
      end

      context "before/after delete hooks" do
        before { instance.flush }

        it "runs before and after delete hooks" do
          instance.delete
          data.should eq([:before_delete, :after_delete])
        end

        it "doesn't run after delete hooks if record wasn't deleted" do
          instance._id = "missing-id"
          instance.delete rescue nil
          data.should eq([:before_delete])
        end
      end

    end
  end
end