require 'spec/spec_helper'

describe StoriesController do
  it 'creates a new story' do
    controller.stub!(:current_user).and_return(Factory(:developer))
    post :create, :story => {:name => 'Group'}
    response.should be_success
  end
end
