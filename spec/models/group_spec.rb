require 'spec_helper'

describe 'Group' do
  describe '#orphaned' do
    it 'should remove stories not assigned to any tasks' do
      story = Factory(:story)
      task = Factory(:task, :story => Factory(:story))
      task_without_story = Factory(:task)
      story2 = task.story
      lambda{Story.remove_orphans}.should change(Story, :count).by -1
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

