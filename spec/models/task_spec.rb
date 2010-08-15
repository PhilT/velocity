require 'spec_helper'

describe Task do
  before(:each) do
    @valid_attributes = {
      :name => 'a task',
      :author => Factory(:customer),
    }
  end

  describe 'moving tasks' do
    it 'does not move task when the velocity is zero' do
      Release.stub!(:velocity => 0)
      done_task = Factory(:task, :state => 'completed')
      task_to_move = Factory(:task, :state => 'pending', :assigned_id => Factory(:developer).id)
      task_to_move.advance!(nil)
      done_task = done_task.reload
      task_to_move.position.should == 2
    end

    it 'does not move task when the only one' do
      Release.stub!(:velocity => 1)
      task_to_move = Factory(:task, :state => 'pending', :assigned_id => Factory(:developer).id)
      task_to_move.advance!(nil).should be_false
    end

    it 'moves task to current releases when started' do
      Release.stub!(:velocity => 1)
      done_task = Factory(:task, :state => 'completed')
      other_task = Factory(:task, :state => 'pending')
      task_to_move = Factory(:task, :state => 'pending', :assigned_id => Factory(:developer).id)
      task_to_move.advance!(nil)
      task_to_move.position.should == 2
    end
  end

  it "should create a new instance given valid attributes" do
    Task.create!(@valid_attributes)
  end

  describe 'form helper methods' do
    it "should handle started" do
      task = Factory :task
      task.started?.should == false
      task.start
      task.started?.should == true
      task.started_on.should_not be_nil
    end

    it "should handle completed" do
      task = Factory(:task)
      task.update_attribute :state, 'started'
      task.completed?.should == false
      task.complete
      task.completed?.should == true
      task.completed_on.should_not be_nil
    end
  end

  it 'should return created tasks' do
    user = Factory(:developer)
    task = Factory(:task)

    created_tasks = Task.created(user)
    created_tasks.size.should == 1
    created_tasks.should include(task)
  end

  it 'should return updated tasks' do
    time = Time.now - 1.day
    task = Factory(:task, :created_at => time)
    task.created_at.should == time

    updated_tasks = Task.updated
    updated_tasks.size.should == 1
    updated_tasks.should include(task)
  end

  it 'should return tasks assigned to user' do
    user = Factory(:developer)
    task = Factory(:task)
    task.assign_to!(user)

    assigned_tasks = Task.assigned_to(user)
    assigned_tasks.size.should == 1
    assigned_tasks.should include(task)
  end

  it 'should cleanup when going from verified to pending' do
    user = Factory(:developer)
    task = Factory(:task, :state => 'verified', :verified_by => user.id, :completed_on => DateTime.now, :started_on => DateTime.now)

    task.advance!(user)

    task.verified_by.should be_nil
    task.completed_on.should be_nil
    task.started_on.should be_nil
  end

  it 'should return correct action' do
    Factory(:task, :state => 'pending').action.should == 'start'
    Factory(:task, :state => 'started').action.should == 'complete'
    Factory(:task, :state => 'completed').action.should == 'merge'
    Factory(:task, :state => 'merged').action.should == 'verify'
    Factory(:task, :state => 'verified').action.should == 'stop'
  end

  it 'return the last started task' do
    pending
  end

end

