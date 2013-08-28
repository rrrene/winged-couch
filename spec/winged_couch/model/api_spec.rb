require 'spec_helper'

describe WingedCouch::Models::API do

  around(:each) do |example|
    OneFieldModel.database.create
    example.run
    OneFieldModel.database.drop
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

end