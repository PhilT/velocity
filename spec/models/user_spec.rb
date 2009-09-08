require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it "should create a new instance given valid attributes" do
    user = Factory :customer
    user.should be_valid
  end

  it "should only get developers" do
    developer = Factory :developer
    customer = Factory :customer
    User.developers.should_not include(customer)
  end
end

