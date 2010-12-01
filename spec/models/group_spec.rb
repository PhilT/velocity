require 'spec_helper'

describe 'Group' do
  describe '#orphaned' do
    it 'deactivates stories not assigned to current tasks' do
      story = Factory(:story)
      task = Factory(:task, :story => Factory(:story))
      task_without_story = Factory(:task)
      story2 = task.story
      Story.remove_orphans
      Story.count.should == 2
      Story.current.count.should == 1
    end
  end

  describe '#activate' do
    it 'activates a group' do
      group = Factory.build(:story, :active => false)
      group.activate
      group.active?.should be_true
    end
  end
end

