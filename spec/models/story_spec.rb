require 'spec/spec_helper.rb'

describe Story do
  describe 'move_to!' do
    before do
      @story = Factory(:story, :release => nil)
      @task = mock_model(Task)
      @story.stub!(:tasks).and_return([@task])
      Release.stub!(:current).and_return(Factory(:release))
    end
    it 'should update position and not update tasks' do
      @task.should_not_receive(:move_to!)
      @story.move_to!(2, Factory(:developer))
    end
  end

  describe 'state' do
    before do
      @story = Story.new
    end
    it 'should be pending when all tasks are pending' do
      @story.stub!(:task_states).and_return(['pending'])
      @story.state.should == 'pending'
    end
    it 'should be verified when all tasks are verified or invalid' do
      @story.stub!(:task_states).and_return(['verified'])
      @story.state.should == 'verified'

      @story.stub!(:task_states).and_return(['verified', 'invalid'])
      @story.state.should == 'verified'
    end
    it 'should be completed when tasks are completed or verified or invalid' do
      @story.stub!(:task_states).and_return(['completed'])
      @story.state.should == 'completed'

      @story.stub!(:task_states).and_return(['completed', 'verified'])
      @story.state.should == 'completed'

      @story.stub!(:task_states).and_return(['completed', 'invalid'])
      @story.state.should == 'completed'

      @story.stub!(:task_states).and_return(['completed', 'verified', 'invalid'])
      @story.state.should == 'completed'
    end
    it 'should be started when at least one task is started or invalid' do
      @story.stub!(:task_states).and_return(['pending', 'invalid'])
      @story.state.should == 'started'

      @story.stub!(:task_states).and_return(['started', 'invalid'])
      @story.state.should == 'started'

      @story.stub!(:task_states).and_return(['started', 'verified', 'invalid'])
      @story.state.should == 'started'

      @story.stub!(:task_states).and_return(['pending', 'verified', 'invalid'])
      @story.state.should == 'started'
    end
  end
end
