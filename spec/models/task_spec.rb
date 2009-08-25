require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  before(:each) do
    @valid_attributes = {
      :category => Enum.find_by_name('Category').enum_values.first,
      :author => Factory(:customer),
      :when => Enum.find_by_name('When').enum_values.first
    }
  end

  it "should create a new instance given valid attributes" do
    Task.create!(@valid_attributes)
  end
end
