require 'spec/spec_helper'

describe StoriesController do
  before do
    controller.stub!(:current_user).and_return(Factory(:developer))
  end

  it 'creates a new story' do
    post :create, :story => {:name => 'Group'}
    response.should be_success
    Story.count.should == 1
  end

  it 'reactivates a previously added story' do
    group = Factory(:story, :name => 'Group', :active => false)
    post :create, :story => {:name => 'Group'}
    response.should be_success
    group.reload.active.should be_true
  end
end
