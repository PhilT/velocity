require 'spec_helper'

describe Sorter do

  describe "verified task" do
    it 'does not move when above pending tasks' do
      original_position = 2
      task = mock(Task, :state => 'pending', :position => original_position)
      Task.stub!(:last_started => mock(Task, :position => 1))
      sorter = Sorter.new
      sorter.update(task)
      task.position.should == original_position
    end
  end

  describe "merged task" do
    it 'does not move when above pending tasks' do
      pending
    end
  end

  describe "completed task" do
    it 'does not move when above pending tasks' do
      pending
    end
  end

  describe "started task" do
    it 'is moved above other pending tasks' do
      pending
    end

    it 'does not move when above pending tasks' do
      pending
    end
  end

  describe "pending task" do
    it 'is moved below other started tasks' do

      task = mock(Task, :state => 'pending', :position => 1)
      task.should_receive(:insert_at).with(2)
      started_task = mock(Task, :state => 'started', :position => 2)
      Task.stub!(:last_started => started_task)

      sorter = Sorter.new
      sorter.update(task)
    end

    it 'does not move when below started tasks' do
      pending
    end
  end

end

