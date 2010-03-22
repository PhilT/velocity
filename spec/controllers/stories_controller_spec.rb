require 'spec/spec_helper'

describe StoriesController do
  before do
    @user = Factory(:developer)
    controller.stub!(:current_user).and_return(@user)
    @story = mock_model(Story)
    @story.stub!(:id).and_return(1)
  end
  it 'should sort' do
    @story.stub!(:release)
    Story.should_receive(:find).twice.with("1").and_return(@story)
    @story.should_receive(:move_to!).with(1, @user)
    put :sort, :id => @story.id, :story => [@story.id.to_s]
  end
end
