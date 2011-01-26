require 'spec/spec_helper'

describe TasksHelper do
  describe '#description_for' do
    it 'returns task name if no story' do
      task = mock_model(Task, :name => 'My Task', :story => nil)
      helper.description_for(task).should == 'My Task'
    end

    it 'includes story name if task has a story' do
      task = mock_model(Task, :name => 'My Task', :story => mock_model(Story, :name => 'Story'))
      helper.description_for(task).should == '[Story] My Task'
    end
  end
end
