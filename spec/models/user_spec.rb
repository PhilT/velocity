require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :name => 'Name',
      :author_id => 1,
      :when_id => 1,
      :effort_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should only get developers" do
    developer = Factory :developer
    customer = Factory :customer
    User.developers.should_not include(customer)
  end
end

