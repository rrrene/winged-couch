require 'spec_helper'

describe WingedCouch::Models::API do

  around(:each) do |example|
    begin
      OneFieldModel.database.create
      example.run
    ensure
      OneFieldModel.database.drop
    end
  end

  it "#new" do
    OneFieldModel.new(field: "value").field.should eq "value"
  end

  it ".create" do
    record_id = OneFieldModel.create(field: "value")._id
    OneFieldModel.record_ids.should eq [record_id]
  end

  it "#inspect" do
    OneFieldModel.new(field: "value").inspect.should eq "#<OneFieldModel field: \"value\", _id: nil, _rev: nil>"
  end

  it ".find" do
    record = OneFieldModel.create(field: 'value')
    OneFieldModel.find(record._id).should eq(record)
  end

  it "#update" do
    record = OneFieldModel.create(field: 'value1')
    record.update(field: 'value2')
    OneFieldModel.find(record._id).field.should eq('value2')
    record.field.should eq('value2')
  end

end