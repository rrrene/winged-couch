require 'spec_helper'

describe WingedCouch::Models::Attributes do

  it ".attribute_names" do
    SimpleModel.attribute_names.should eq [:name, :gender, :number, :unsupported]
  end

  it "#attributes" do
    s = SimpleModel.new
    s.name = "name"
    s.gender = "gender"
    s.number = "123"
    expected_attributes = { name: "name",
      gender: :gender,
      number: 123,
      unsupported: nil
    }
    s.attributes.should eq expected_attributes
  end

  describe "#attribute" do
    it "default value" do
      s = SimpleModel.new
      s.gender.should eq "male"
    end

    it "raises error if class for type-casting is not supported" do
      expect { SimpleModel.new.unsupported = nil }.to raise_error WingedCouch::UnsupportedType
    end
  end

end