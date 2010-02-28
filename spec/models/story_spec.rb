require 'spec/spec_helper.rb'

describe Story do
  describe 'move_to!' do
    before do
      @story = Factory(:story, :release => nil)
      @task = mock_model(Task)
      @story.stub!(:tasks).and_return([@task])
      Release.stub!(:current).and_return(Factory(:release))
    end
    it 'should move story with tasks from future to current release' do
      @task.should_receive(:move_to!)
      @story.move_to!(2, Release.current, Factory(:developer))
    end
    it 'should update position and not update tasks' do
      @task.should_not_receive(:move_to!)
      @story.move_to!(2, nil, Factory(:developer))
    end
  end
end
